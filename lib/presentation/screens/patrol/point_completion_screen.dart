import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/patrol_tour_model.dart';
import '../../../main.dart';
import 'widgets/task_input_widget.dart';
import 'simple_qr_scanner_screen.dart';

class PointCompletionScreen extends ConsumerStatefulWidget {
  final PatrolPointModel point;
  final PatrolInstanceModel instance;
  final PatrolPointCompletionModel? existingCompletion;
  final String tenantId;

  const PointCompletionScreen({
    super.key,
    required this.point,
    required this.instance,
    this.existingCompletion,
    required this.tenantId,
  });

  @override
  ConsumerState<PointCompletionScreen> createState() => _PointCompletionScreenState();
}

class _PointCompletionScreenState extends ConsumerState<PointCompletionScreen> {
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _scanVerified = false;
  String? _scanMethod;
  String? _photoPath;
  double? _latitude;
  double? _longitude;
  bool _withinGeofence = true;

  // Task responses: taskId -> {value, isCompleted}
  final Map<String, Map<String, dynamic>> _taskResponses = {};

  @override
  void initState() {
    super.initState();
    _initializeFromExisting();
    _getCurrentLocation();
  }

  void _initializeFromExisting() {
    if (widget.existingCompletion != null) {
      _scanVerified = widget.existingCompletion!.scanVerified;
      _scanMethod = widget.existingCompletion!.scanMethod;
      _photoPath = widget.existingCompletion!.photoLocalPath;
      _notesController.text = widget.existingCompletion!.notes ?? '';
      _latitude = widget.existingCompletion!.latitude;
      _longitude = widget.existingCompletion!.longitude;
      _withinGeofence = widget.existingCompletion!.withinGeofence;

      // Load task responses
      if (widget.existingCompletion!.taskResponses != null) {
        for (final response in widget.existingCompletion!.taskResponses!) {
          _taskResponses[response.patrolTaskId] = {
            'value': response.responseValue,
            'isCompleted': response.isCompleted,
          };
        }
      }
    }

    // Initialize task responses for all tasks
    if (widget.point.tasks != null) {
      for (final task in widget.point.tasks!) {
        if (!_taskResponses.containsKey(task.id)) {
          _taskResponses[task.id] = {
            'value': null,
            'isCompleted': false,
          };
        }
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentLocation();

      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _withinGeofence = _checkGeofence();
        });
      }
    } catch (e) {
      // Location error, will be handled when completing
    }
  }

  bool _checkGeofence() {
    if (_latitude == null || _longitude == null) return true;
    if (widget.point.latitude == null || widget.point.longitude == null) return true;

    // Simple distance check using Haversine approximation
    const double earthRadius = 6371e3; // meters
    final lat1 = _latitude! * 0.0174533; // Convert to radians
    final lat2 = widget.point.latitude! * 0.0174533;
    final deltaLat = (widget.point.latitude! - _latitude!) * 0.0174533;
    final deltaLng = (widget.point.longitude! - _longitude!) * 0.0174533;

    final a = (deltaLat / 2) * (deltaLat / 2) +
        lat1.abs() * lat2.abs() * (deltaLng / 2) * (deltaLng / 2);
    final c = 2 * a.abs().clamp(0.0, 1.0);
    final distance = earthRadius * c;

    return distance <= widget.point.geofenceRadius;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasUnsatisfiedRequirements = !_validateRequirements();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.point.checkpointName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Point info card
                  _buildPointInfoCard(),
                  const SizedBox(height: 16),

                  // Geofence status
                  if (widget.point.hasGeofence) ...[
                    _buildGeofenceStatus(),
                    const SizedBox(height: 16),
                  ],

                  // Scan requirement
                  if (widget.point.requireScan) ...[
                    _buildScanSection(),
                    const SizedBox(height: 16),
                  ],

                  // Photo requirement
                  if (widget.point.requirePhoto) ...[
                    _buildPhotoSection(),
                    const SizedBox(height: 16),
                  ],

                  // Tasks
                  if (widget.point.tasks != null && widget.point.tasks!.isNotEmpty) ...[
                    _buildTasksSection(),
                    const SizedBox(height: 16),
                  ],

                  // Notes
                  _buildNotesSection(),
                  const SizedBox(height: 24),

                  // Complete button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: hasUnsatisfiedRequirements ? null : _completePoint,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Complete Checkpoint'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  if (hasUnsatisfiedRequirements) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Complete all required items to continue',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildPointInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.point.checkpointName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Code: ${widget.point.checkpointCode}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.point.instructions != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.point.instructions!,
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGeofenceStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _withinGeofence ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _withinGeofence ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _withinGeofence ? Icons.check_circle : Icons.warning,
            color: _withinGeofence ? Colors.green[700] : Colors.orange[700],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _withinGeofence ? 'Within checkpoint area' : 'Outside checkpoint area',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _withinGeofence ? Colors.green[700] : Colors.orange[700],
                  ),
                ),
                if (!_withinGeofence)
                  Text(
                    'You may be too far from this checkpoint',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[600],
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: _getCurrentLocation,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildScanSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _scanVerified ? Icons.check_circle : Icons.qr_code_scanner,
                  color: _scanVerified ? Colors.green : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Scan Checkpoint',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                if (_scanVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _scanMethod?.toUpperCase() ?? 'VERIFIED',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _scanQRCode,
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Scan QR'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _scanNFC,
                    icon: const Icon(Icons.nfc),
                    label: const Text('Scan NFC'),
                  ),
                ),
              ],
            ),
            if (!_scanVerified) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _verifyScan('manual'),
                child: const Text('I cannot scan - verify manually'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _photoPath != null ? Icons.check_circle : Icons.camera_alt,
                  color: _photoPath != null ? Colors.green : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Photo Evidence',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (widget.point.requirePhoto) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Required',
                      style: TextStyle(fontSize: 10, color: Colors.red[700]),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            if (_photoPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_photoPath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.refresh),
                label: const Text('Retake Photo'),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTasksSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Tasks',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                Text(
                  '${_completedTasksCount()}/${widget.point.tasks!.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...widget.point.tasks!.map((task) {
              final response = _taskResponses[task.id];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TaskInputWidget(
                  task: task,
                  value: response?['value'],
                  isCompleted: response?['isCompleted'] ?? false,
                  onChanged: (value, isCompleted) {
                    setState(() {
                      _taskResponses[task.id] = {
                        'value': value,
                        'isCompleted': isCompleted,
                      };
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Notes',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (widget.point.requireNotes) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Required',
                      style: TextStyle(fontSize: 10, color: Colors.red[700]),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add any observations or notes...',
                border: OutlineInputBorder(),
              ),
              validator: widget.point.requireNotes
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Notes are required for this checkpoint';
                      }
                      return null;
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  int _completedTasksCount() {
    return _taskResponses.values.where((r) => r['isCompleted'] == true).length;
  }

  bool _validateRequirements() {
    // Check scan requirement
    if (widget.point.requireScan && !_scanVerified) return false;

    // Check photo requirement
    if (widget.point.requirePhoto && _photoPath == null) return false;

    // Check notes requirement
    if (widget.point.requireNotes && _notesController.text.trim().isEmpty) return false;

    // Check required tasks
    if (widget.point.tasks != null) {
      for (final task in widget.point.tasks!) {
        if (task.isRequired) {
          final response = _taskResponses[task.id];
          if (response == null || response['isCompleted'] != true) {
            return false;
          }
        }
      }
    }

    return true;
  }

  void _scanQRCode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleQRScannerScreen(),
      ),
    );

    if (result != null && result == widget.point.checkpointCode) {
      _verifyScan('qr');
    } else if (result != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR code does not match this checkpoint'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scanNFC() async {
    // NFC scanning would be implemented here
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('NFC scanning not yet implemented'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _verifyScan(String method) {
    setState(() {
      _scanVerified = true;
      _scanMethod = method;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checkpoint verified via ${method.toUpperCase()}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _photoPath = image.path;
      });
    }
  }

  void _completePoint() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateRequirements()) return;

    setState(() => _isLoading = true);

    try {
      final patrolTourRepo = ref.read(patrolTourRepositoryProvider);

      // Build task responses
      final taskResponses = <Map<String, dynamic>>[];
      _taskResponses.forEach((taskId, response) {
        taskResponses.add({
          'taskId': taskId,
          'value': response['value'],
          'isCompleted': response['isCompleted'],
        });
      });

      final completion = await patrolTourRepo.completePatrolPoint(
        instanceId: widget.instance.id,
        pointId: widget.point.id,
        tenantId: widget.tenantId,
        latitude: _latitude ?? 0,
        longitude: _longitude ?? 0,
        scanVerified: _scanVerified,
        scanMethod: _scanMethod,
        photoLocalPath: _photoPath,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        taskResponses: taskResponses,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Checkpoint completed!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, completion);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete checkpoint: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

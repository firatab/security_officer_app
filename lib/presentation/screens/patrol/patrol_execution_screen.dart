import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/patrol_tour_model.dart';
import '../../../main.dart';
import 'point_completion_screen.dart';

class PatrolExecutionScreen extends ConsumerStatefulWidget {
  final PatrolInstanceModel instance;
  final PatrolTourModel tour;
  final String employeeId;
  final String tenantId;

  const PatrolExecutionScreen({
    super.key,
    required this.instance,
    required this.tour,
    required this.employeeId,
    required this.tenantId,
  });

  @override
  ConsumerState<PatrolExecutionScreen> createState() => _PatrolExecutionScreenState();
}

class _PatrolExecutionScreenState extends ConsumerState<PatrolExecutionScreen> {
  late PatrolInstanceModel _instance;
  late List<PatrolPointModel> _points;
  final Map<String, PatrolPointCompletionModel> _completions = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _instance = widget.instance;
    _points = widget.tour.points ?? [];
    _loadCompletions();
  }

  void _loadCompletions() {
    // Load existing completions into map
    if (widget.instance.pointCompletions != null) {
      for (final completion in widget.instance.pointCompletions!) {
        _completions[completion.patrolPointId] = completion;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _instance.totalPoints > 0
        ? _instance.completedPoints / _instance.totalPoints
        : 0.0;

    return PopScope(
      canPop: _instance.completedPoints == 0 || _instance.isComplete,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmation();
        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.tour.name),
          actions: [
            if (_instance.isInProgress)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'abandon') {
                    _abandonPatrol();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'abandon',
                    child: Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Abandon Patrol', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        body: Column(
          children: [
            // Progress header
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${_instance.completedPoints}/${_instance.totalPoints} points',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  if (_instance.actualStart != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Started: ${_formatTime(_instance.actualStart!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ],
              ),
            ),

            // Points list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _points.length,
                      itemBuilder: (context, index) {
                        final point = _points[index];
                        return _buildPointCard(context, point, index);
                      },
                    ),
            ),

            // Complete patrol button
            if (_instance.completedPoints == _instance.totalPoints &&
                !_instance.isComplete)
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _completePatrol,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Complete Patrol'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointCard(BuildContext context, PatrolPointModel point, int index) {
    final completion = _completions[point.id];
    final isCompleted = completion?.status == 'completed';
    final isLocked = widget.tour.sequenceRequired && index > 0 && !_isPreviousPointCompleted(index);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isLocked ? null : () => _openPointCompletion(point, completion),
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Sequence number / status icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green
                        : isLocked
                            ? Colors.grey[300]
                            : Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : isLocked
                            ? const Icon(Icons.lock, color: Colors.grey, size: 20)
                            : Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  ),
                ),
                const SizedBox(width: 16),

                // Point info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point.checkpointName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            point.checkpointCode,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          if (point.instructions != null) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.info_outline, size: 14, color: Colors.grey[400]),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (point.requireScan)
                            _buildRequirementChip(Icons.qr_code_scanner, 'Scan'),
                          if (point.requirePhoto)
                            _buildRequirementChip(Icons.camera_alt, 'Photo'),
                          if (point.requireNotes)
                            _buildRequirementChip(Icons.edit_note, 'Notes'),
                          if (point.tasks != null && point.tasks!.isNotEmpty)
                            _buildRequirementChip(
                                Icons.checklist, '${point.tasks!.length} tasks'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Chevron
                if (!isLocked)
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  bool _isPreviousPointCompleted(int index) {
    if (index == 0) return true;
    final previousPoint = _points[index - 1];
    final completion = _completions[previousPoint.id];
    return completion?.status == 'completed';
  }

  void _openPointCompletion(PatrolPointModel point, PatrolPointCompletionModel? existingCompletion) async {
    final result = await Navigator.push<PatrolPointCompletionModel>(
      context,
      MaterialPageRoute(
        builder: (context) => PointCompletionScreen(
          point: point,
          instance: _instance,
          existingCompletion: existingCompletion,
          tenantId: widget.tenantId,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _completions[point.id] = result;
        if (result.status == 'completed') {
          _instance = PatrolInstanceModel(
            id: _instance.id,
            serverId: _instance.serverId,
            tenantId: _instance.tenantId,
            patrolTourId: _instance.patrolTourId,
            scheduleId: _instance.scheduleId,
            shiftId: _instance.shiftId,
            employeeId: _instance.employeeId,
            scheduledStart: _instance.scheduledStart,
            actualStart: _instance.actualStart,
            actualEnd: _instance.actualEnd,
            status: _instance.status,
            totalPoints: _instance.totalPoints,
            completedPoints: _instance.completedPoints + 1,
            startLatitude: _instance.startLatitude,
            startLongitude: _instance.startLongitude,
            notes: _instance.notes,
            needsSync: _instance.needsSync,
            syncedAt: _instance.syncedAt,
            createdAt: _instance.createdAt,
            updatedAt: DateTime.now(),
          );
        }
      });
    }
  }

  Future<bool?> _showExitConfirmation() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Patrol?'),
        content: const Text(
          'Your progress has been saved. You can continue this patrol later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _completePatrol() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Patrol'),
        content: const Text(
          'Are you sure you want to complete this patrol? '
          'All checkpoints have been visited.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final patrolTourRepo = ref.read(patrolTourRepositoryProvider);
      await patrolTourRepo.completePatrolInstance(_instance.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patrol completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete patrol: $e'),
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

  void _abandonPatrol() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abandon Patrol?'),
        content: const Text(
          'Are you sure you want to abandon this patrol? '
          'Your progress will be saved but the patrol will be marked as abandoned.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Abandon'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final patrolTourRepo = ref.read(patrolTourRepositoryProvider);
      await patrolTourRepo.abandonPatrolInstance(_instance.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patrol abandoned'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to abandon patrol: $e'),
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

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

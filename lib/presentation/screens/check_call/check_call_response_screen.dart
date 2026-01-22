import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/utils/logger.dart';
import '../../../main.dart';
import '../../../services/websocket_service.dart';

/// Check Call Response Screen
///
/// This screen is displayed when a check call alarm is triggered.
/// The officer must respond within 7 minutes to confirm their safety.
class CheckCallResponseScreen extends ConsumerStatefulWidget {
  final String checkCallId;
  final String shiftId;
  final String siteName;
  final DateTime scheduledTime;
  final DateTime dueTime;
  final bool isUrgent;

  const CheckCallResponseScreen({
    super.key,
    required this.checkCallId,
    required this.shiftId,
    required this.siteName,
    required this.scheduledTime,
    required this.dueTime,
    this.isUrgent = false,
  });

  @override
  ConsumerState<CheckCallResponseScreen> createState() => _CheckCallResponseScreenState();
}

class _CheckCallResponseScreenState extends ConsumerState<CheckCallResponseScreen>
    with TickerProviderStateMixin {
  late Timer _countdownTimer;
  late AnimationController _pulseController;
  Duration _remainingTime = Duration.zero;
  bool _isResponding = false;
  String _selectedStatus = 'ok';
  final _notesController = TextEditingController();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startCountdown();
    _getCurrentLocation();

    // Pulse animation for urgent alerts
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _pulseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    _remainingTime = widget.dueTime.difference(now);
    if (_remainingTime.isNegative) {
      _remainingTime = Duration.zero;
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _calculateRemainingTime();
        if (_remainingTime.inSeconds <= 0) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      AppLogger.error('Error getting location for check call', e);
    }
  }

  Future<void> _respondToCheckCall() async {
    if (_isResponding) return;

    setState(() {
      _isResponding = true;
    });

    try {
      // Get fresh location
      await _getCurrentLocation();

      // Send response via WebSocket
      final wsController = ref.read(webSocketProvider.notifier);
      wsController.sendCheckCallResponse(
        widget.checkCallId,
        _selectedStatus,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // Also send via HTTP API for reliability
      final checkCallRepository = ref.read(checkCallRepositoryProvider);
      await checkCallRepository.respondToCheckCall(
        shiftId: widget.shiftId,
        checkCallId: widget.checkCallId,
        status: _selectedStatus,
        scheduledTime: widget.scheduledTime,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        latitude: _currentPosition?.latitude,
        longitude: _currentPosition?.longitude,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check call response submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      AppLogger.error('Error responding to check call', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit response: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResponding = false;
        });
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getUrgencyColor() {
    if (_remainingTime.inSeconds <= 0) {
      return Colors.red;
    } else if (_remainingTime.inMinutes <= 2) {
      return Colors.red;
    } else if (_remainingTime.inMinutes <= 4) {
      return Colors.orange;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpired = _remainingTime.inSeconds <= 0;
    final urgencyColor = _getUrgencyColor();

    return Scaffold(
      backgroundColor: urgencyColor.withValues(alpha: 0.1),
      appBar: AppBar(
        title: const Text('Check Call Required'),
        backgroundColor: urgencyColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Countdown timer section
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: urgencyColor.withValues(
                      alpha: widget.isUrgent ? 0.3 + (_pulseController.value * 0.2) : 0.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isExpired ? Icons.warning : Icons.access_alarm,
                        size: 64,
                        color: urgencyColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isExpired ? 'TIME EXPIRED' : 'RESPOND NOW',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: urgencyColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDuration(_remainingTime),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: urgencyColor,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Time remaining to respond',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Site info card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: theme.colorScheme.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.siteName,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Scheduled at: ${_formatTime(widget.scheduledTime)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Status selection
                    Text(
                      'Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusOption('ok', 'All OK', 'Everything is fine', Icons.check_circle, Colors.green),
                    _buildStatusOption('alert', 'Alert', 'Need assistance but not emergency', Icons.warning, Colors.orange),
                    _buildStatusOption('late', 'Late Response', 'Responding late but okay', Icons.access_time, Colors.blue),

                    const SizedBox(height: 16),

                    // Notes field
                    Text(
                      'Notes (Optional)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add any notes...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Location info
                    if (_currentPosition != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Icon(Icons.my_location, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              'Location captured',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),

                    // Submit button
                    ElevatedButton(
                      onPressed: _isResponding ? null : _respondToCheckCall,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isResponding
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'SUBMIT RESPONSE',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 16),

                    // Emergency button
                    OutlinedButton(
                      onPressed: () {
                        // Navigate to panic alert
                        Navigator.of(context).pushNamed('/panic');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.emergency, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'EMERGENCY - TRIGGER PANIC ALERT',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(String value, String title, String subtitle, IconData icon, Color color) {
    final isSelected = _selectedStatus == value;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? color : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedStatus = value;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isSelected ? color : Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: color),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// Show check call response dialog as a modal
Future<bool?> showCheckCallAlarmDialog(
  BuildContext context, {
  required String checkCallId,
  required String shiftId,
  required String siteName,
  required DateTime scheduledTime,
  required DateTime dueTime,
  bool isUrgent = false,
}) {
  return Navigator.of(context).push<bool>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => CheckCallResponseScreen(
        checkCallId: checkCallId,
        shiftId: shiftId,
        siteName: siteName,
        scheduledTime: scheduledTime,
        dueTime: dueTime,
        isUrgent: isUrgent,
      ),
    ),
  );
}

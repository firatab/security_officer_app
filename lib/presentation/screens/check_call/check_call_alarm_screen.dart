import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/logger.dart';
import '../../../data/database/app_database.dart';

import '../../../services/location_service.dart';
import '../../../main.dart'; // For checkCallRepositoryProvider

/// Full-screen alarm screen for check calls
/// Shows even when device is locked and app is killed
class CheckCallAlarmScreen extends ConsumerStatefulWidget {
  final String checkCallId;
  final String shiftId;
  final DateTime scheduledTime;

  const CheckCallAlarmScreen({
    super.key,
    required this.checkCallId,
    required this.shiftId,
    required this.scheduledTime,
  });

  @override
  ConsumerState<CheckCallAlarmScreen> createState() =>
      _CheckCallAlarmScreenState();
}

class _CheckCallAlarmScreenState extends ConsumerState<CheckCallAlarmScreen>
    with WidgetsBindingObserver {
  CheckCall? _checkCall;
  bool _isResponding = false;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCheckCall();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadCheckCall() async {
    try {
      final repository = ref.read(checkCallRepositoryProvider);
      final checkCall = await repository.getCheckCallById(widget.checkCallId);

      if (mounted) {
        setState(() {
          _checkCall = checkCall;
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.error('Error loading check call', e);
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _respondToCheckCall() async {
    if (_isResponding) return;

    setState(() {
      _isResponding = true;
      _error = null;
    });

    try {
      // Get current location
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();

      // Respond via repository
      await ref
          .read(checkCallRepositoryProvider)
          .respondToCheckCallOnline(
            shiftId: widget.shiftId,
            checkCallId: widget.checkCallId,
            status: 'ok',
            scheduledTime: widget.scheduledTime,
            latitude: position.latitude,
            longitude: position.longitude,
          );

      AppLogger.info('Check call responded: ${widget.checkCallId}');

      // Close the alarm screen
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      AppLogger.error('Error responding to check call', e);
      setState(() {
        _error = 'Failed to respond: $e';
        _isResponding = false;
      });
    }
  }

  Future<void> _snooze() async {
    // Close the alarm screen
    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isOverdue = now.isAfter(widget.scheduledTime);
    final timeUntil = widget.scheduledTime.difference(now);

    return Scaffold(
      backgroundColor: isOverdue ? Colors.red.shade900 : Colors.orange.shade900,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isOverdue
                  ? [Colors.red.shade900, Colors.red.shade700]
                  : [Colors.orange.shade900, Colors.orange.shade700],
            ),
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            isOverdue
                                ? Icons.warning_rounded
                                : Icons.notifications_active_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isOverdue
                                ? 'CHECK CALL OVERDUE!'
                                : 'CHECK CALL ALARM',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Time card
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Scheduled time
                            Text(
                              'Scheduled Time',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatTime(widget.scheduledTime),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(widget.scheduledTime),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Time until/overdue
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isOverdue
                                    ? 'OVERDUE BY ${_formatDuration(timeUntil.abs())}'
                                    : 'IN ${_formatDuration(timeUntil)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),

                            if (_error != null) ...[
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Respond button
                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: ElevatedButton(
                              onPressed: _isResponding
                                  ? null
                                  : _respondToCheckCall,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                elevation: 8,
                                shadowColor: Colors.black.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isResponding
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle, size: 28),
                                        SizedBox(width: 12),
                                        Text(
                                          'RESPOND NOW',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Snooze button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: _isResponding ? null : _snooze,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.snooze, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    'SNOOZE (5 MIN)',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}

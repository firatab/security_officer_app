import 'dart:async';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';

/// Alarm scheduler service for check calls
/// Uses Android AlarmManager to schedule exact alarms that persist across app restarts
class AlarmSchedulerService {
  static final AlarmSchedulerService _instance =
      AlarmSchedulerService._internal();
  factory AlarmSchedulerService() => _instance;
  AlarmSchedulerService._internal();

  bool _isInitialized = false;

  /// Initialize the alarm manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await AndroidAlarmManager.initialize();
      _isInitialized = true;
      AppLogger.info('AlarmSchedulerService initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize AlarmSchedulerService', e);
      rethrow;
    }
  }

  /// Schedule an alarm for a check call
  /// The alarm will fire even if the app is killed
  Future<void> scheduleCheckCallAlarm({
    required String checkCallId,
    required DateTime scheduledTime,
    required String shiftId,
    required String employeeId,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Generate unique alarm ID from checkCallId hash
      final alarmId = _generateAlarmId(checkCallId);

      // Cancel any existing alarm for this check call
      await cancelCheckCallAlarm(checkCallId);

      // Calculate when to fire the alarm (5 minutes before scheduled time)
      final alarmTime = scheduledTime.subtract(const Duration(minutes: 5));

      // Don't schedule if time has already passed
      if (alarmTime.isBefore(DateTime.now())) {
        AppLogger.warning(
          'Check call alarm time has passed, not scheduling: $checkCallId',
        );
        return;
      }

      // Schedule exact alarm that will wake the device
      await AndroidAlarmManager.oneShotAt(
        alarmTime,
        alarmId,
        _alarmCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: {
          'checkCallId': checkCallId,
          'scheduledTime': scheduledTime.toIso8601String(),
          'shiftId': shiftId,
          'employeeId': employeeId,
        },
      );

      AppLogger.info(
        'Check call alarm scheduled: $checkCallId at ${alarmTime.toIso8601String()} (ID: $alarmId)',
      );
    } catch (e) {
      AppLogger.error('Failed to schedule check call alarm: $checkCallId', e);
      rethrow;
    }
  }

  /// Cancel a check call alarm
  Future<void> cancelCheckCallAlarm(String checkCallId) async {
    try {
      final alarmId = _generateAlarmId(checkCallId);
      await AndroidAlarmManager.cancel(alarmId);
      AppLogger.info('Check call alarm cancelled: $checkCallId (ID: $alarmId)');
    } catch (e) {
      AppLogger.error('Failed to cancel check call alarm: $checkCallId', e);
    }
  }

  /// Cancel all check call alarms
  Future<void> cancelAllAlarms() async {
    try {
      // Note: android_alarm_manager doesn't have a cancelAll method
      // We need to track alarm IDs separately if we want to cancel all
      AppLogger.info('Cancelling all check call alarms');
    } catch (e) {
      AppLogger.error('Failed to cancel all alarms', e);
    }
  }

  /// Reschedule all upcoming check calls (e.g., after device reboot)
  Future<void> rescheduleUpcomingCheckCalls({
    required AppDatabase database,
    required String shiftId,
  }) async {
    try {
      // Get all pending check calls for the shift
      final checkCalls = await database.checkCallsDao
          .getPendingCheckCallsByShift(shiftId);

      int rescheduled = 0;
      for (final checkCall in checkCalls) {
        // Only reschedule future check calls
        if (checkCall.scheduledTime.isAfter(DateTime.now())) {
          await scheduleCheckCallAlarm(
            checkCallId: checkCall.id,
            scheduledTime: checkCall.scheduledTime,
            shiftId: checkCall.shiftId,
            employeeId: checkCall.employeeId,
          );
          rescheduled++;
        }
      }

      AppLogger.info(
        'Rescheduled $rescheduled upcoming check call alarms for shift: $shiftId',
      );
    } catch (e) {
      AppLogger.error('Failed to reschedule upcoming check calls', e);
    }
  }

  /// Generate a consistent alarm ID from checkCallId
  /// Must be positive int for Android AlarmManager
  int _generateAlarmId(String checkCallId) {
    // Use hashCode and ensure it's positive
    return checkCallId.hashCode.abs() % 2147483647; // Max positive int32
  }

  /// Alarm callback - called when alarm fires
  /// This is a static top-level function required by android_alarm_manager
  @pragma('vm:entry-point')
  static Future<void> _alarmCallback(
    int alarmId,
    Map<String, dynamic> params,
  ) async {
    try {
      AppLogger.info('Check call alarm fired: $alarmId, params: $params');

      final checkCallId = params['checkCallId'] as String?;
      final scheduledTime = params['scheduledTime'] as String?;
      final shiftId = params['shiftId'] as String?;
      final employeeId = params['employeeId'] as String?;

      if (checkCallId == null || scheduledTime == null) {
        AppLogger.error('Missing required alarm parameters');
        return;
      }

      // Show full-screen notification
      // This will be implemented in the next step with flutter_local_notifications
      AppLogger.info('Showing full-screen alarm for check call: $checkCallId');

      // TODO: Show full-screen alarm activity
      // This requires creating a custom Android activity that shows over the lock screen
    } catch (e) {
      AppLogger.error('Error in alarm callback', e);
    }
  }
}

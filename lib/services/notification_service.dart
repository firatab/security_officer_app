import 'dart:async';
import 'dart:ui' show Color;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../core/utils/logger.dart';
import '../core/constants/app_constants.dart';

import 'notification_dedup_service.dart';

/// Notification service for check calls and other alerts
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final NotificationDedupService _dedupService = NotificationDedupService();

  // Stream controller for notification taps
  final StreamController<String> _onNotificationTapController =
      StreamController<String>.broadcast();
  Stream<String> get onNotificationTap => _onNotificationTapController.stream;

  bool _initialized = false;
  bool _permissionsGranted = false;

  // Notification channels
  static const String checkCallChannelId = 'check_call_channel';
  static const String checkCallChannelName = 'Check Calls';
  static const String checkCallChannelDescription =
      'Notifications for security check calls';

  static const String generalChannelId = 'general_channel';
  static const String generalChannelName = 'General';
  static const String generalChannelDescription = 'General app notifications';

  static const String newJobChannelId = 'new_job_channel';
  static const String newJobChannelName = 'New Job Assignments';
  static const String newJobChannelDescription =
      'Notifications for new job assignments';

  // Notification IDs
  static const int checkCallNotificationId = 1000;
  static const int shiftReminderNotificationId = 2000;
  static const int newJobNotificationId = 3000;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz_data.initializeTimeZones();

    // Android initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    await _createNotificationChannels();

    // Request permissions
    _permissionsGranted = await requestPermissions();

    _initialized = true;
    AppLogger.info(
      'Notification service initialized. Permissions granted: $_permissionsGranted',
    );
  }

  /// Create Android notification channels
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Location tracking channel - MUST be created BEFORE background service starts
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.locationChannelId,
          AppConstants.locationChannelName,
          description: 'Used for location tracking during shifts',
          importance: Importance.low,
          playSound: false,
          enableVibration: false,
        ),
      );

      // Background sync notification channels
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'shift_updates',
          'Shift Updates',
          description: 'Notifications for shift assignments and changes',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'check_call_reminders',
          'Check Call Reminders',
          description: 'Reminders for upcoming check calls',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );

      // Check call channel with alarm sound
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          checkCallChannelId,
          checkCallChannelName,
          description: checkCallChannelDescription,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        ),
      );

      // General channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          generalChannelId,
          generalChannelName,
          description: generalChannelDescription,
          importance: Importance.defaultImportance,
        ),
      );

      // New job assignment channel with high importance
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          newJobChannelId,
          newJobChannelName,
          description: newJobChannelDescription,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        ),
      );
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.info('Notification tapped: ${response.payload}');
    if (response.payload != null) {
      _onNotificationTapController.add(response.payload!);
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (kIsWeb) return true; // Permissions not needed for web

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidPlugin = _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        final granted = await androidPlugin?.requestNotificationsPermission();
        return granted ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosPlugin = _notifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        final granted = await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    } catch (e) {
      AppLogger.error('Failed to request notification permissions', e);
    }
    return false;
  }

  Future<void> _showNotification(
    int id,
    String title,
    String body,
    NotificationDetails details, {
    String? payload,
  }) async {
    if (!_initialized) {
      AppLogger.warning(
        'Notification service not initialized. Cannot show notification.',
      );
      return;
    }
    if (!_permissionsGranted) {
      AppLogger.warning(
        'Notification permissions not granted. Cannot show notification.',
      );
      return;
    }

    // Check for duplicates using payload or create ID from title+body
    final notifId = payload ?? '$title:$body';
    final shouldShow = await _dedupService.shouldShowNotification(notifId);

    if (!shouldShow) {
      AppLogger.debug('Skipping duplicate notification: $title');
      return;
    }

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// Show check call notification (high priority with alarm)
  Future<void> showCheckCallNotification({
    required String checkCallId,
    required String siteName,
    String? message,
  }) async {
    final vibrationPattern = Int64List.fromList([0, 500, 200, 500, 200, 500]);

    final androidDetails = AndroidNotificationDetails(
      checkCallChannelId,
      checkCallChannelName,
      channelDescription: checkCallChannelDescription,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: vibrationPattern,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      autoCancel: false,
      ongoing: true,
      actions: const [
        AndroidNotificationAction(
          'respond',
          'Respond Now',
          showsUserInterface: true,
        ),
        AndroidNotificationAction('snooze', 'Snooze 5 min'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _showNotification(
      checkCallNotificationId,
      'Check Call Required',
      message ?? 'Please respond to your check call for $siteName',
      details,
      payload: 'check_call:$checkCallId',
    );

    AppLogger.info('Check call notification shown for: $checkCallId');
  }

  /// Show check call ALARM notification (high priority with alarm sound for URGENT response)
  /// This is used when a check call is actively due and needs immediate response
  Future<void> showCheckCallAlarmNotification({
    required String checkCallId,
    required String shiftId,
    required String siteName,
    required String message,
    bool isUrgent = false,
    DateTime? scheduledTime,
    DateTime? dueTime,
  }) async {
    // Create a more aggressive vibration pattern for urgent alarms
    final vibrationPattern = isUrgent
        ? Int64List.fromList([0, 1000, 500, 1000, 500, 1000, 500, 1000])
        : Int64List.fromList([0, 500, 200, 500, 200, 500]);

    final androidDetails = AndroidNotificationDetails(
      checkCallChannelId,
      checkCallChannelName,
      channelDescription: checkCallChannelDescription,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: vibrationPattern,
      fullScreenIntent: true, // Shows as full screen on lock screen
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      autoCancel: false,
      ongoing: true, // Cannot be swiped away
      colorized: true,
      color: isUrgent ? const Color(0xFFFF0000) : const Color(0xFFFF9800),
      ticker: 'CHECK CALL REQUIRED - RESPOND NOW',
      subText: isUrgent ? 'URGENT' : null,
      actions: const [
        AndroidNotificationAction(
          'respond_ok',
          'I\'m OK',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'respond_alert',
          'Need Help',
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel:
          InterruptionLevel.critical, // Will play even in silent mode
      sound: 'alarm.aiff', // Custom alarm sound
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use a stable notification ID so we can update/cancel it
    const alarmNotificationId = 999;

    await _showNotification(
      alarmNotificationId,
      'CHECK CALL - RESPOND NOW',
      '$siteName: $message',
      details,
      payload:
          'check_call_alarm:$checkCallId:$shiftId:${scheduledTime?.toIso8601String()}:${dueTime?.toIso8601String()}',
    );

    AppLogger.warning(
      'CHECK CALL ALARM notification shown for: $checkCallId (urgent: $isUrgent)',
    );
  }

  /// Cancel the check call alarm notification
  Future<void> cancelCheckCallAlarm() async {
    await _notifications.cancel(999);
    AppLogger.info('Check call alarm cancelled');
  }

  /// Schedule a check call notification
  Future<void> scheduleCheckCallNotification({
    required String checkCallId,
    required String siteName,
    required DateTime scheduledTime,
    String? message,
  }) async {
    if (!_permissionsGranted) {
      AppLogger.warning(
        'Notification permissions not granted. Cannot schedule notification.',
      );
      return;
    }
    final vibrationPattern = Int64List.fromList([0, 500, 200, 500, 200, 500]);

    final androidDetails = AndroidNotificationDetails(
      checkCallChannelId,
      checkCallChannelName,
      channelDescription: checkCallChannelDescription,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: vibrationPattern,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Generate unique ID from checkCallId hash
    final notificationId =
        checkCallId.hashCode.abs() % 100000 + checkCallNotificationId;

    await _notifications.zonedSchedule(
      notificationId,
      'Check Call Required',
      message ?? 'Please respond to your check call for $siteName',
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      payload: 'check_call:$checkCallId',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    AppLogger.info(
      'Scheduled check call notification for $scheduledTime: $checkCallId',
    );
  }

  /// Cancel a scheduled check call notification
  Future<void> cancelCheckCallNotification(String checkCallId) async {
    final notificationId =
        checkCallId.hashCode.abs() % 100000 + checkCallNotificationId;
    await _notifications.cancel(notificationId);
    AppLogger.info('Cancelled check call notification: $checkCallId');
  }

  /// Cancel all check call notifications
  Future<void> cancelAllCheckCallNotifications() async {
    // Cancel the main check call notification
    await _notifications.cancel(checkCallNotificationId);
    AppLogger.info('Cancelled all check call notifications');
  }

  /// Show new job assignment notification
  Future<void> showNewJobNotification({
    required String shiftId,
    required String siteName,
    required DateTime startTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      newJobChannelId,
      newJobChannelName,
      channelDescription: newJobChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      category: AndroidNotificationCategory.event,
      visibility: NotificationVisibility.public,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Format the date and time
    final dateStr = '${startTime.day}/${startTime.month}/${startTime.year}';
    final timeStr =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

    // Generate unique notification ID
    final notificationId =
        shiftId.hashCode.abs() % 100000 + newJobNotificationId;

    await _showNotification(
      notificationId,
      'New Job Assignment!',
      'You have been assigned to $siteName on $dateStr at $timeStr. Tap to view details.',
      details,
      payload: 'new_job:$shiftId',
    );

    AppLogger.info(
      'New job notification shown for shift: $shiftId at $siteName',
    );
  }

  /// Show shift reminder notification
  Future<void> showShiftReminderNotification({
    required String shiftId,
    required String siteName,
    required DateTime startTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      generalChannelId,
      generalChannelName,
      channelDescription: generalChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final timeString =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

    await _showNotification(
      shiftReminderNotificationId,
      'Shift Reminder',
      'Your shift at $siteName starts at $timeString',
      details,
      payload: 'shift:$shiftId',
    );
  }

  /// Show a general notification
  Future<void> showGeneralNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      generalChannelId,
      generalChannelName,
      channelDescription: generalChannelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _showNotification(id, title, body, details, payload: payload);
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}

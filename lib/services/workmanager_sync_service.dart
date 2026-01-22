import 'dart:async';
import 'dart:ui';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/api_endpoints.dart';

/// WorkManager callback dispatcher (MUST be top-level function)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('🔄 Background sync task started: $task');
      
      // Perform background sync
      await _performBackgroundSync();
      
      print('✅ Background sync task completed');
      return Future.value(true);
    } catch (e) {
      print('❌ Background sync task failed: $e');
      return Future.value(false);
    }
  });
}

/// Main background sync logic
Future<void> _performBackgroundSync() async {
  try {
    // Get auth credentials
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    final token = await storage.read(key: AppConstants.accessTokenKey);
    
    if (token == null) {
      print('Not authenticated, skipping background sync');
      return;
    }

    // Get server URL
    final prefs = await SharedPreferences.getInstance();
    final serverUrl = prefs.getString('server_api_url') ?? AppConstants.baseUrl;

    // Create Dio client for API calls
    final dio = Dio(BaseOptions(
      baseUrl: serverUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    // Initialize notifications
    final notifications = FlutterLocalNotificationsPlugin();
    await _initializeNotifications(notifications);

    // Fetch data from server and check for changes
    await _checkForNewShifts(dio, prefs, notifications);
    await _checkForUpcomingCheckCalls(dio, prefs, notifications);
    await _checkForMessages(dio, prefs, notifications);

  } catch (e) {
    print('Error in background sync: $e');
  }
}

/// Initialize notification plugin
Future<void> _initializeNotifications(FlutterLocalNotificationsPlugin notifications) async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );
  
  await notifications.initialize(initSettings);

  // Create notification channels
  await notifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
        const AndroidNotificationChannel(
          'shift_updates',
          'Shift Updates',
          description: 'Notifications for shift assignments and changes',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
      );

  await notifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
        const AndroidNotificationChannel(
          'check_call_reminders',
          'Check Call Reminders',
          description: 'Reminders for upcoming check calls',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );
}

/// Check for new or updated shifts
Future<void> _checkForNewShifts(Dio dio, SharedPreferences prefs, FlutterLocalNotificationsPlugin notifications) async {
  try {
    final lastCheck = prefs.getString('bg_last_shift_check');
    final since = lastCheck ?? DateTime.now().subtract(const Duration(hours: 24)).toIso8601String();

    final response = await dio.get(
      ApiEndpoints.shifts,
      queryParameters: {
        'from': DateTime.now().toIso8601String(),
        'to': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'updatedSince': since,
      },
    );

    if (response.statusCode == 200 && response.data['data'] != null) {
      final shifts = response.data['data'] as List;
      final lastShiftIds = prefs.getStringList('bg_known_shift_ids') ?? [];

      for (final shift in shifts) {
        final shiftId = shift['id'] as String;
        final siteName = shift['site']?['name'] ?? 'Unknown Site';
        final startTime = DateTime.parse(shift['startTime'] as String);

        // New shift detected
        if (!lastShiftIds.contains(shiftId)) {
          await _showNotification(
            notifications,
            'New Shift Assigned! 🎯',
            '$siteName - ${_formatDateTime(startTime)}',
            'shift_updates',
            shiftId.hashCode,
          );
          lastShiftIds.add(shiftId);
        }
      }

      await prefs.setStringList('bg_known_shift_ids', lastShiftIds);
      await prefs.setString('bg_last_shift_check', DateTime.now().toIso8601String());
    }
  } catch (e) {
    print('Error checking shifts: $e');
  }
}

/// Check for upcoming check calls
Future<void> _checkForUpcomingCheckCalls(Dio dio, SharedPreferences prefs, FlutterLocalNotificationsPlugin notifications) async {
  try {
    final response = await dio.get(
      '/api/check-calls/upcoming',
      queryParameters: {'next': 30}, // Next 30 minutes
    );

    if (response.statusCode == 200 && response.data['data'] != null) {
      final checkCalls = response.data['data'] as List;
      final notifiedCalls = prefs.getStringList('bg_notified_calls') ?? [];

      for (final checkCall in checkCalls) {
        final callId = checkCall['id'] as String;
        final scheduledTime = DateTime.parse(checkCall['scheduledTime'] as String);
        final minutesUntil = scheduledTime.difference(DateTime.now()).inMinutes;

        // Notify 10 minutes before check call (only once)
        if (minutesUntil <= 10 && minutesUntil > 0 && !notifiedCalls.contains(callId)) {
          await _showNotification(
            notifications,
            'Check Call in $minutesUntil minutes ⏰',
            'Please be ready to respond',
            'check_call_reminders',
            callId.hashCode,
          );
          notifiedCalls.add(callId);
          await prefs.setStringList('bg_notified_calls', notifiedCalls);
        }
      }
    }
  } catch (e) {
    print('Error checking check calls: $e');
  }
}

/// Check for new messages/notifications
Future<void> _checkForMessages(Dio dio, SharedPreferences prefs, FlutterLocalNotificationsPlugin notifications) async {
  try {
    final lastCheck = prefs.getString('bg_last_message_check');
    final since = lastCheck ?? DateTime.now().subtract(const Duration(hours: 1)).toIso8601String();

    final response = await dio.get(
      ApiEndpoints.mobileNotifications,
      queryParameters: {'since': since, 'unread': true},
    );

    if (response.statusCode == 200 && response.data['data'] != null) {
      final messages = response.data['data'] as List;
      final notifiedMessages = prefs.getStringList('bg_notified_messages') ?? [];

      for (final message in messages) {
        final messageId = message['id'] as String;
        
        // Only show if not already notified
        if (!notifiedMessages.contains(messageId)) {
          final title = message['title'] ?? 'New Message';
          final body = message['message'] ?? '';
          
          await _showNotification(
            notifications,
            title,
            body,
            'shift_updates',
            messageId.hashCode,
          );
          notifiedMessages.add(messageId);
        }
      }

      await prefs.setStringList('bg_notified_messages', notifiedMessages);
      await prefs.setString('bg_last_message_check', DateTime.now().toIso8601String());
    }
  } catch (e) {
    print('Error checking messages: $e');
  }
}

/// Show a notification
Future<void> _showNotification(
  FlutterLocalNotificationsPlugin notifications,
  String title,
  String body,
  String channelId,
  int id,
) async {
  final androidDetails = AndroidNotificationDetails(
    channelId,
    channelId == 'shift_updates' ? 'Shift Updates' : 'Check Call Reminders',
    importance: channelId == 'check_call_reminders' ? Importance.max : Importance.high,
    priority: channelId == 'check_call_reminders' ? Priority.max : Priority.high,
    playSound: true,
    enableVibration: true,
  );

  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  final details = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await notifications.show(id, title, body, details);
  print('📱 Showed notification: $title');
}

/// Format date and time for display
String _formatDateTime(DateTime dt) {
  final day = dt.day.toString().padLeft(2, '0');
  final month = dt.month.toString().padLeft(2, '0');
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '$day/$month at $hour:$minute';
}

/// WorkManager-based background service for periodic data sync
/// Runs every 15 minutes (Android minimum) even when app is closed
class BackgroundSyncService {
  static const String taskName = 'background-data-sync';
  static const String uniqueName = 'bg-sync-15min';
  // Android minimum is 15 minutes for periodic tasks
  static const Duration syncInterval = Duration(minutes: 15);

  static final BackgroundSyncService _instance = BackgroundSyncService._internal();
  factory BackgroundSyncService() => _instance;
  BackgroundSyncService._internal();

  /// Initialize WorkManager and register periodic task
  Future<void> initialize() async {
    try {
      // IMPORTANT: Must call DartPluginRegistrant for background isolates
      DartPluginRegistrant.ensureInitialized();
      
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true, // Set to false in production
      );
      
      await registerPeriodicTask();
      print('🔄 WorkManager background sync service initialized');
    } catch (e) {
      print('Failed to initialize WorkManager: $e');
    }
  }

  /// Register the periodic sync task
  Future<void> registerPeriodicTask() async {
    try {
      await Workmanager().registerPeriodicTask(
        uniqueName,
        taskName,
        frequency: syncInterval,
        constraints: Constraints(
          networkType: NetworkType.connected, // Only run when connected
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
        initialDelay: const Duration(minutes: 1), // First run after 1 minute
      );
      print('📅 Periodic background sync registered (every 15 minutes)');
    } catch (e) {
      print('Failed to register periodic task: $e');
    }
  }

  /// Cancel the background sync task
  Future<void> cancel() async {
    try {
      await Workmanager().cancelByUniqueName(uniqueName);
      print('❌ Background sync cancelled');
    } catch (e) {
      print('Failed to cancel background sync: $e');
    }
  }
}

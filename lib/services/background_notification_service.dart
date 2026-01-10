import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';
import 'notification_service.dart';

/// Background service for polling notifications when app is closed
class BackgroundNotificationService {
  static const String _lastCheckKey = 'last_notification_check';
  static const String _isRunningKey = 'bg_notification_running';

  static final BackgroundNotificationService _instance =
      BackgroundNotificationService._internal();
  factory BackgroundNotificationService() => _instance;
  BackgroundNotificationService._internal();

  final FlutterBackgroundService _service = FlutterBackgroundService();

  /// Initialize the background service
  Future<void> initialize() async {
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: false,
        autoStartOnBoot: true,
        initialNotificationTitle: 'Security Officer',
        initialNotificationContent: 'Checking for updates...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  /// Start the background service
  Future<void> start() async {
    final isRunning = await _service.isRunning();
    if (!isRunning) {
      await _service.startService();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isRunningKey, true);
    }
  }

  /// Stop the background service
  Future<void> stop() async {
    _service.invoke('stop');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isRunningKey, false);
  }

  /// Check if service is running
  Future<bool> isRunning() async {
    return await _service.isRunning();
  }
}

/// iOS background handler
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return true;
}

/// Main background service entry point
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Initialize notifications for background
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Handle stop command
  service.on('stop').listen((event) {
    service.stopSelf();
  });

  // Poll for notifications every 2 minutes
  Timer.periodic(const Duration(minutes: 2), (timer) async {
    await _checkForNotifications(notificationService);
  });

  // Also check immediately on start
  await _checkForNotifications(notificationService);
}

/// Check server for new notifications
Future<void> _checkForNotifications(NotificationService notificationService) async {
  try {
    final storage = const FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();

    // Get auth token
    final token = await storage.read(key: AppConstants.accessTokenKey);
    if (token == null) {
      return; // Not logged in
    }

    // Get server URL
    final serverUrl = prefs.getString('server_api_url') ?? AppConstants.baseUrl;

    // Get last check timestamp
    final lastCheck = prefs.getString(BackgroundNotificationService._lastCheckKey);
    final since = lastCheck ?? DateTime.now().subtract(const Duration(hours: 24)).toIso8601String();

    // Create Dio instance for this request
    final dio = Dio(BaseOptions(
      baseUrl: serverUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    // Fetch pending notifications from server
    final response = await dio.get(
      '/api/mobile/notifications',
      queryParameters: {'since': since},
    );

    if (response.statusCode == 200 && response.data['data'] != null) {
      final notifications = response.data['data'] as List;

      for (final notification in notifications) {
        await _showNotification(notificationService, notification);
      }

      // Update last check timestamp
      await prefs.setString(
        BackgroundNotificationService._lastCheckKey,
        DateTime.now().toIso8601String(),
      );
    }
  } catch (e) {
    // Silently fail - will retry on next poll
    // Background services can't use app logger, error is expected during network issues
  }
}

/// Show a notification based on server data
Future<void> _showNotification(
  NotificationService notificationService,
  Map<String, dynamic> data,
) async {
  final type = data['type'] as String?;
  final id = data['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString();

  switch (type) {
    case 'new_job_assignment':
      final shiftData = data['shift'] as Map<String, dynamic>?;
      if (shiftData != null) {
        await notificationService.showNewJobNotification(
          shiftId: shiftData['id'] ?? id,
          siteName: shiftData['siteName'] ?? 'Unknown Site',
          startTime: shiftData['startTime'] != null
              ? DateTime.parse(shiftData['startTime'])
              : DateTime.now(),
        );
      }
      break;

    case 'check_call_reminder':
      await notificationService.showCheckCallNotification(
        checkCallId: data['checkCallId'] ?? id,
        siteName: data['siteName'] ?? 'your site',
        message: data['message'] ?? 'Check call required now!',
      );
      break;

    case 'shift_update':
      await notificationService.showGeneralNotification(
        id: id.hashCode,
        title: data['title'] ?? 'Shift Update',
        body: data['message'] ?? 'Your shift has been updated.',
        payload: jsonEncode(data),
      );
      break;

    default:
      // Generic notification
      if (data['title'] != null || data['message'] != null) {
        await notificationService.showGeneralNotification(
          id: id.hashCode,
          title: data['title'] ?? 'Notification',
          body: data['message'] ?? '',
          payload: jsonEncode(data),
        );
      }
  }
}

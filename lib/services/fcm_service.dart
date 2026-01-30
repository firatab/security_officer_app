import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/utils/logger.dart';
import '../core/network/dio_client.dart';
import '../core/constants/app_constants.dart';
import '../data/database/app_database.dart';
import '../main.dart' hide dioClientProvider;
import 'notification_service.dart';
import 'notification_dedup_service.dart';

/// Provider for FCM Service
final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService(ref);
});

/// Firebase Cloud Messaging Service
/// Handles push notifications for both Android and iOS
class FCMService {
  final Ref _ref;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();
  final NotificationDedupService _dedupService = NotificationDedupService();

  String? _fcmToken;
  bool _initialized = false;

  FCMService(this._ref);

  /// Initialize FCM
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Request permission for notifications
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        AppLogger.info('FCM: Push notification permission granted');

        // Get FCM token
        _fcmToken = await _getFcmToken();
        if (_fcmToken != null) {
          AppLogger.info(
            'FCM Token obtained: ${_fcmToken!.substring(0, 20)}...',
          );

          // Register token with backend server
          await _registerTokenWithServer(_fcmToken!);
        } else {
          AppLogger.warning('FCM: Failed to get token');
        }

        // Listen for token refresh
        _fcm.onTokenRefresh.listen((newToken) {
          AppLogger.info('FCM Token refreshed');
          _fcmToken = newToken;
          _registerTokenWithServer(newToken);
        });

        // Handle foreground messages (when app is open)
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // Handle background messages (when app is in background but not killed)
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

        // Handle notification tap when app was completely closed
        final initialMessage = await _fcm.getInitialMessage();
        if (initialMessage != null) {
          AppLogger.info('FCM: App opened from notification (was terminated)');
          _handleMessageOpenedApp(initialMessage);
        }

        _initialized = true;
        AppLogger.info('FCM Service initialized successfully');
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        AppLogger.warning('FCM: Push notification permission denied');
      } else {
        AppLogger.warning(
          'FCM: Push notification permission not determined yet',
        );
      }
    } catch (e) {
      AppLogger.error('FCM initialization failed', e);
    }
  }

  /// Handle foreground message (app is open and active)
  void _handleForegroundMessage(RemoteMessage message) async {
    AppLogger.info(
      'FCM: Foreground message received: ${message.notification?.title}',
    );

    // Check for duplicate using message ID
    final messageId =
        message.messageId ?? message.data.toString().hashCode.abs().toString();
    final shouldShow = await _dedupService.shouldShowNotification(messageId);

    if (!shouldShow) {
      AppLogger.debug('Skipping duplicate FCM message: $messageId');
      return;
    }

    // Save to in-app notifications database
    try {
      final database = _ref.read(databaseProvider);

      // Get current tenant and employee from secure storage
      final storage = const FlutterSecureStorage();
      final tenantId = await storage.read(key: AppConstants.tenantIdKey) ?? '';
      final employeeId =
          await storage.read(key: AppConstants.employeeIdKey) ?? '';

      if (tenantId.isNotEmpty && employeeId.isNotEmpty) {
        await database.inAppNotificationsDao.insertNotification(
          InAppNotificationsCompanion.insert(
            id: messageId,
            tenantId: tenantId,
            employeeId: employeeId,
            title: message.notification?.title ?? 'Notification',
            body: message.notification?.body ?? '',
            type: message.data['type'] as String? ?? 'general',
            priority: Value(message.data['priority'] as String? ?? 'normal'),
            iconType: Value(message.data['iconType'] as String?),
            relatedEntityType: Value(
              message.data['relatedEntityType'] as String?,
            ),
            relatedEntityId: Value(message.data['relatedEntityId'] as String?),
            actionRoute: Value(message.data['actionRoute'] as String?),
            receivedAt: DateTime.now(),
          ),
        );
        AppLogger.debug('FCM: Notification saved to database');
      } else {
        AppLogger.warning(
          'FCM: Cannot save notification - user not authenticated',
        );
      }
    } catch (e) {
      AppLogger.error('FCM: Failed to save notification to database', e);
      // Continue to show notification even if database save fails
    }

    if (message.notification != null) {
      // Show local notification using flutter_local_notifications
      _notificationService.showGeneralNotification(
        id: message.hashCode,
        title: message.notification!.title ?? 'Notification',
        body: message.notification!.body ?? '',
        payload: messageId, // Use messageId as payload for tracking
      );
    }
  }

  /// Handle message when app was opened from notification
  /// This is called when user taps on notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    AppLogger.info('FCM: App opened from notification: ${message.data}');

    // Navigate based on notification type
    final type = message.data['type'] as String?;
    final notificationType = message.data['notificationType'] as String?;

    // TODO: Implement navigation based on type
    // Example:
    // if (type == 'check_call') {
    //   // Navigate to check calls screen
    // } else if (type == 'shift_assignment') {
    //   // Navigate to shifts screen
    // }

    AppLogger.info(
      'Notification type: $type, notificationType: $notificationType',
    );
  }

  /// Register FCM token with backend server
  Future<void> _registerTokenWithServer(String token) async {
    try {
      final dioClient = _ref.read(dioClientProvider);

      final platform = _resolvePlatform();

      await dioClient.post(
        '/api/push-tokens',
        data: {
          'token': token,
          'platform': platform,
          'deviceId': await _getDeviceId(),
          'deviceType': platform,
          'appVersion': '1.0.0', // TODO: Get from package_info_plus
        },
      );

      AppLogger.info('FCM: Token registered with server successfully');
    } catch (e) {
      AppLogger.error('FCM: Failed to register token with server', e);
      // Don't throw - token registration failure shouldn't break app initialization
    }
  }

  /// Get device ID for token management
  /// You can use device_info_plus package for more detailed device info
  Future<String> _getDeviceId() async {
    // For now, use a simple identifier
    // TODO: Implement proper device ID using device_info_plus
    final platform = _resolvePlatform();
    return 'device_${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Get current FCM token
  String? get fcmToken => _fcmToken;

  /// Refresh FCM token manually
  Future<String?> refreshToken() async {
    try {
      await _fcm.deleteToken();
      final newToken = await _getFcmToken();
      if (newToken != null) {
        _fcmToken = newToken;
        await _registerTokenWithServer(newToken);
        AppLogger.info('FCM: Token manually refreshed');
      }
      return newToken;
    } catch (e) {
      AppLogger.error('FCM: Failed to refresh token', e);
      return null;
    }
  }

  /// Unregister token (call on logout)
  Future<void> unregister() async {
    if (_fcmToken != null) {
      try {
        final dioClient = _ref.read(dioClientProvider);

        // Unregister from server
        await dioClient.delete('/api/push-tokens', data: {'token': _fcmToken});

        // Delete FCM token
        await _fcm.deleteToken();
        _fcmToken = null;

        AppLogger.info('FCM: Token unregistered successfully');
      } catch (e) {
        AppLogger.error('FCM: Failed to unregister token', e);
      }
    }
  }

  /// Check if FCM is initialized and has a token
  bool get isInitialized => _initialized && _fcmToken != null;
}

Future<String?> _getFcmToken() async {
  if (kIsWeb) {
    const vapidKey = String.fromEnvironment('FIREBASE_WEB_VAPID_KEY');
    if (vapidKey.isEmpty) {
      AppLogger.warning('FCM: Missing FIREBASE_WEB_VAPID_KEY for web');
      return null;
    }
    return FirebaseMessaging.instance.getToken(vapidKey: vapidKey);
  }

  return FirebaseMessaging.instance.getToken();
}

String _resolvePlatform() {
  if (kIsWeb) return 'web';

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'android';
    case TargetPlatform.iOS:
      return 'ios';
    case TargetPlatform.windows:
    case TargetPlatform.macOS:
    case TargetPlatform.linux:
    case TargetPlatform.fuchsia:
      return 'web';
  }
}

/// Background message handler (top-level function required by Firebase)
/// This MUST be a top-level function, not a class method
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp();

  AppLogger.info(
    'FCM Background: Message received: ${message.notification?.title}',
  );

  // You can process the message here if needed
  // Note: This runs in a separate isolate, so you can't update UI directly

  // The notification is automatically shown by the system
  // You can customize behavior by adding custom logic here
}

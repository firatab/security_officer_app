import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/logger.dart';
import 'notification_service.dart';
import 'websocket_service.dart';

/// Provider for PushNotificationService
final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService(ref);
});

/// Service to handle push notifications via WebSocket (local solution - no Firebase)
///
/// This service listens to WebSocket events and shows local notifications.
/// When the app is in the foreground, notifications are shown via flutter_local_notifications.
/// When the app is in the background, the background service handles WebSocket events.
class PushNotificationService {
  final Ref _ref;
  final NotificationService _notificationService = NotificationService();

  StreamSubscription? _notificationSubscription;
  StreamSubscription? _checkCallSubscription;
  StreamSubscription? _shiftSubscription;
  StreamSubscription? _incidentSubscription;
  StreamSubscription? _panicSubscription;

  bool _initialized = false;

  PushNotificationService(this._ref);

  /// Initialize the push notification service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize local notification service
      await _notificationService.initialize();

      // Subscribe to WebSocket events for notifications
      _subscribeToWebSocketEvents();

      _initialized = true;
      AppLogger.info('Push notification service initialized (WebSocket-based)');
    } catch (e) {
      AppLogger.error('Failed to initialize push notification service', e);
    }
  }

  /// Subscribe to WebSocket events and show notifications
  void _subscribeToWebSocketEvents() {
    try {
      final wsController = _ref.read(webSocketProvider.notifier);

      // Listen for push notification events from server
      _notificationSubscription = wsController.notificationStream.listen(
        _handlePushNotification,
        onError: (e) => AppLogger.error('Notification stream error', e),
      );

      // Listen for check call events
      _checkCallSubscription = wsController.checkCallStream.listen(
        _handleCheckCallNotification,
        onError: (e) => AppLogger.error('Check call stream error', e),
      );

      // Listen for shift events
      _shiftSubscription = wsController.shiftUpdates.listen(
        _handleShiftNotification,
        onError: (e) => AppLogger.error('Shift stream error', e),
      );

      // Listen for incident events
      _incidentSubscription = wsController.incidentStream.listen(
        _handleIncidentNotification,
        onError: (e) => AppLogger.error('Incident stream error', e),
      );

      // Listen for panic alerts
      _panicSubscription = wsController.panicStream.listen(
        _handlePanicNotification,
        onError: (e) => AppLogger.error('Panic stream error', e),
      );

      AppLogger.info('Subscribed to WebSocket notification events');
    } catch (e) {
      AppLogger.error('Failed to subscribe to WebSocket events', e);
    }
  }

  /// Handle generic push notification from server
  void _handlePushNotification(Map<String, dynamic> data) {
    final title = data['title'] as String? ?? 'Notification';
    final body = data['body'] as String? ?? '';
    final type = data['type'] as String?;

    AppLogger.info('Received push notification: $type');

    _notificationService.showGeneralNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      payload: data.toString(),
    );
  }

  /// Handle check call notification
  void _handleCheckCallNotification(Map<String, dynamic> data) {
    final eventType = data['_eventType'] as String?;
    final checkCallId = data['id'] as String? ?? data['checkCallId'] as String? ?? '';
    final shiftId = data['shiftId'] as String? ?? '';
    final siteName = data['siteName'] as String? ?? 'your site';
    final scheduledTimeStr = data['scheduledTime'] as String?;
    final dueTimeStr = data['dueTime'] as String? ?? data['deadline'] as String?;
    final isUrgent = data['isUrgent'] as bool? ?? false;
    final remainingMinutes = data['remainingMinutes'] as int?;

    // Parse dates
    DateTime? scheduledTime;
    DateTime? dueTime;
    try {
      if (scheduledTimeStr != null) scheduledTime = DateTime.parse(scheduledTimeStr);
      if (dueTimeStr != null) dueTime = DateTime.parse(dueTimeStr);
    } catch (_) {}

    if (eventType == SocketEvent.checkCallAlarm) {
      // This is an ALARM - check call is due NOW
      // Show high-priority alarm notification with sound
      String message = 'RESPOND NOW to confirm you are safe!';
      if (remainingMinutes != null && remainingMinutes > 0) {
        message = 'You have $remainingMinutes minute${remainingMinutes > 1 ? 's' : ''} to respond!';
      }

      _notificationService.showCheckCallAlarmNotification(
        checkCallId: checkCallId,
        shiftId: shiftId,
        siteName: siteName,
        message: message,
        isUrgent: isUrgent,
        scheduledTime: scheduledTime,
        dueTime: dueTime,
      );

      AppLogger.warning('CHECK CALL ALARM: $siteName - $message');
    } else if (eventType == SocketEvent.checkCallUpcoming) {
      // Advance notice - check call is coming up soon
      _notificationService.showCheckCallNotification(
        checkCallId: checkCallId,
        siteName: siteName,
        message: 'Check call coming up - be ready to respond',
      );

      AppLogger.info('Check call upcoming notification: $siteName');
    } else if (eventType == SocketEvent.checkCallDue ||
        eventType == SocketEvent.checkCallCreated) {
      String message = 'Please respond to confirm you are safe';
      if (dueTime != null) {
        final minutes = dueTime.difference(DateTime.now()).inMinutes;
        if (minutes > 0) {
          message = 'Respond within $minutes minutes';
        }
      }

      _notificationService.showCheckCallNotification(
        checkCallId: checkCallId,
        siteName: siteName,
        message: message,
      );

      AppLogger.info('Showed check call notification');
    }
  }

  /// Handle shift notification
  void _handleShiftNotification(Map<String, dynamic> data) {
    final eventType = data['_eventType'] as String?;
    final siteName = data['siteName'] as String? ?? 'a site';

    String? title;
    String? body;

    switch (eventType) {
      case SocketEvent.shiftCreated:
        title = 'New Shift Assigned';
        body = 'You have been assigned a new shift at $siteName';
        break;
      case SocketEvent.shiftUpdated:
        title = 'Shift Updated';
        body = 'Your shift at $siteName has been updated';
        break;
      case SocketEvent.shiftDeleted:
        title = 'Shift Cancelled';
        body = 'Your shift at $siteName has been cancelled';
        break;
    }

    if (title != null && body != null) {
      _notificationService.showGeneralNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: body,
        payload: data.toString(),
      );

      AppLogger.info('Showed shift notification: $eventType');
    }
  }

  /// Handle incident notification
  void _handleIncidentNotification(Map<String, dynamic> data) {
    final eventType = data['_eventType'] as String?;
    final siteName = data['siteName'] as String? ?? 'a site';
    final severity = data['severity'] as String?;

    if (eventType == SocketEvent.incidentCreated) {
      _notificationService.showGeneralNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'New Incident Reported',
        body: 'A ${severity ?? 'new'} incident was reported at $siteName',
        payload: data.toString(),
      );

      AppLogger.info('Showed incident notification');
    }
  }

  /// Handle panic alert notification (high priority)
  void _handlePanicNotification(Map<String, dynamic> data) {
    final eventType = data['_eventType'] as String?;
    final employeeName = data['employeeName'] as String? ?? 'An officer';
    final siteName = data['siteName'] as String? ?? 'unknown location';

    if (eventType == SocketEvent.panicAlert) {
      // Show high-priority notification for panic alerts
      _notificationService.showGeneralNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'PANIC ALERT',
        body: '$employeeName triggered a panic alert at $siteName!',
        payload: data.toString(),
      );

      AppLogger.warning('Showed PANIC ALERT notification');
    }
  }

  /// Register for push notifications (via WebSocket)
  /// This is called after login to register the device with the server
  Future<void> registerToken() async {
    // With WebSocket-based notifications, we don't need FCM tokens
    // The WebSocket connection itself serves as the notification channel
    // The server tracks connected sockets via the push:register event

    try {
      final wsController = _ref.read(webSocketProvider.notifier);

      // The WebSocket service already handles device registration
      // Just ensure we're connected
      if (!wsController.isConnected) {
        AppLogger.info('WebSocket not connected, notifications will work when connected');
      } else {
        AppLogger.info('Push notifications active via WebSocket');
      }
    } catch (e) {
      AppLogger.error('Failed to register for push notifications', e);
    }
  }

  /// Unregister from push notifications
  Future<void> unregisterToken() async {
    // WebSocket disconnection handles unregistration automatically
    AppLogger.info('Push notification token unregistered');
  }

  /// Clean up subscriptions
  void dispose() {
    _notificationSubscription?.cancel();
    _checkCallSubscription?.cancel();
    _shiftSubscription?.cancel();
    _incidentSubscription?.cancel();
    _panicSubscription?.cancel();
    _initialized = false;
    AppLogger.info('Push notification service disposed');
  }
}

/// Socket event types (mirrors server-side SocketEvent enum)
class SocketEvent {
  static const String shiftCreated = 'shift:created';
  static const String shiftUpdated = 'shift:updated';
  static const String shiftDeleted = 'shift:deleted';
  static const String attendanceBookOn = 'attendance:book_on';
  static const String attendanceBookOff = 'attendance:book_off';
  static const String checkCallCreated = 'check_call:created';
  static const String checkCallDue = 'check_call:due';
  static const String checkCallResponded = 'check_call:responded';
  static const String checkCallMissed = 'check_call:missed';
  static const String checkCallAlarm = 'check_call_alarm';
  static const String checkCallUpcoming = 'check_call_upcoming';
  static const String incidentCreated = 'incident:created';
  static const String incidentUpdated = 'incident:updated';
  static const String panicAlert = 'panic:alert';
  static const String panicAcknowledged = 'panic:acknowledged';
  static const String locationUpdate = 'location:update';
}

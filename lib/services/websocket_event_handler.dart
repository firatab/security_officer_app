import 'dart:async';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';
import '../data/repositories/shift_repository.dart';
import '../data/repositories/check_call_repository.dart';
import 'notification_service.dart';
import 'websocket_service.dart';

/// Handles WebSocket events and updates local state accordingly
class WebSocketEventHandler {
  final WebSocketController _wsController;
  final AppDatabase _database;
  final ShiftRepository _shiftRepository;
  final CheckCallRepository _checkCallRepository;
  final NotificationService _notificationService;

  StreamSubscription? _subscription;

  // Callbacks for UI updates
  Function()? onShiftUpdated;
  Function(String shiftId, String siteName, DateTime startTime)? onNewJobAssignment;
  Function(String checkCallId)? onCheckCallReminder;
  Function(String checkCallId)? onCheckCallMissed;
  Function(String message)? onNotification;

  WebSocketEventHandler({
    required WebSocketController wsController,
    required AppDatabase database,
    required ShiftRepository shiftRepository,
    required CheckCallRepository checkCallRepository,
    required NotificationService notificationService,
  })  : _wsController = wsController,
        _database = database,
        _shiftRepository = shiftRepository,
        _checkCallRepository = checkCallRepository,
        _notificationService = notificationService;

  /// Start listening to WebSocket messages
  void startListening() {
    _subscription?.cancel();
    _subscription = _wsController.messageStream.listen(_handleMessage);
    AppLogger.info('WebSocket event handler started');
  }

  /// Stop listening to WebSocket messages
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    AppLogger.info('WebSocket event handler stopped');
  }

  /// Handle incoming WebSocket message
  Future<void> _handleMessage(WebSocketMessage message) async {
    AppLogger.debug('Handling WebSocket message: ${message.type}');

    switch (message.type) {
      case SocketEvent.shiftCreated:
      case SocketEvent.shiftUpdated:
      case SocketEvent.shiftDeleted:
        await _handleShiftUpdate(message.data);
        break;
      case SocketEvent.checkCallCreated:
        await _handleCheckCallReminder(message.data);
        break;
      case SocketEvent.checkCallMissed:
        await _handleCheckCallMissed(message.data);
        break;
      case SocketEvent.checkCallAlert:
        await _handleCheckCallReminder(message.data);
        break;
      case SocketEvent.attendanceBookOn:
      case SocketEvent.attendanceBookOff:
      case SocketEvent.attendanceUpdated:
        await _handleAttendanceUpdate(message.data);
        break;
      case SocketEvent.locationUpdate:
        await _handleLocationRequest(message.data);
        break;
      case SocketEvent.notificationNew:
      case SocketEvent.pushNotification:
        await _handleNotification(message.data);
        break;
      case SocketEvent.panicAlert:
        await _handlePanicAlert(message.data);
        break;
      default:
        AppLogger.debug('Unhandled message type: ${message.type}');
    }
  }

  /// Handle panic alert - critical priority
  Future<void> _handlePanicAlert(Map<String, dynamic> data) async {
    try {
      final siteName = data['site']?['name'] as String? ?? 'Unknown Site';
      final reporterName = data['reporterName'] as String? ?? 'Unknown';
      final incidentId = data['incidentId'] as String?;

      AppLogger.info('PANIC ALERT received: $siteName by $reporterName');

      // Show high-priority notification
      await _notificationService.showGeneralNotification(
        id: incidentId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
        title: '⚠️ PANIC ALERT',
        body: '$reporterName triggered panic alert at $siteName',
        payload: 'panic_alert:$incidentId',
      );
    } catch (e) {
      AppLogger.error('Error handling panic alert', e);
    }
  }

  /// Handle shift update message
  Future<void> _handleShiftUpdate(Map<String, dynamic> data) async {
    try {
      final action = data['action'] as String?;
      final shiftData = data['shift'] as Map<String, dynamic>?;

      if (shiftData == null) {
        AppLogger.warning('Shift update missing shift data');
        return;
      }

      final shiftId = shiftData['id'] as String;

      switch (action) {
        case 'created':
        case 'updated':
          // Sync the updated shift from server
          await _shiftRepository.syncShifts();
          AppLogger.info('Shift synced: $shiftId ($action)');
          break;
        case 'deleted':
          // Remove shift from local database
          await (_database.delete(_database.shifts)
                ..where((tbl) => tbl.id.equals(shiftId)))
              .go();
          AppLogger.info('Shift deleted locally: $shiftId');
          break;
      }

      // Notify UI
      onShiftUpdated?.call();

      // Show notification for new shifts
      if (action == 'created') {
        final siteName = shiftData['siteName'] as String? ?? 'Unknown Site';
        final startTimeStr = shiftData['startTime'] as String?;
        final startTime = startTimeStr != null
            ? DateTime.tryParse(startTimeStr) ?? DateTime.now()
            : DateTime.now();
        await _notificationService.showShiftReminderNotification(
          shiftId: shiftId,
          siteName: siteName,
          startTime: startTime,
        );
      }
    } catch (e) {
      AppLogger.error('Error handling shift update', e);
    }
  }

  /// Handle check call reminder
  Future<void> _handleCheckCallReminder(Map<String, dynamic> data) async {
    try {
      final checkCallId = data['checkCallId'] as String;
      final siteName = data['siteName'] as String? ?? 'your site';

      AppLogger.info('Check call reminder received: $checkCallId');

      // Show immediate notification
      await _notificationService.showCheckCallNotification(
        checkCallId: checkCallId,
        siteName: siteName,
        message: 'Check call required now! Please respond.',
      );

      // Notify UI
      onCheckCallReminder?.call(checkCallId);
    } catch (e) {
      AppLogger.error('Error handling check call reminder', e);
    }
  }

  /// Handle check call missed notification
  Future<void> _handleCheckCallMissed(Map<String, dynamic> data) async {
    try {
      final checkCallId = data['checkCallId'] as String;

      AppLogger.info('Check call missed notification: $checkCallId');

      // Update local database
      await _checkCallRepository.markCheckCallMissed(checkCallId);

      // Show notification
      await _notificationService.showGeneralNotification(
        id: checkCallId.hashCode,
        title: 'Check Call Missed',
        body: 'You missed a check call. Please contact your supervisor.',
        payload: 'check_call_missed:$checkCallId',
      );

      // Notify UI
      onCheckCallMissed?.call(checkCallId);
    } catch (e) {
      AppLogger.error('Error handling check call missed', e);
    }
  }

  /// Handle attendance update
  Future<void> _handleAttendanceUpdate(Map<String, dynamic> data) async {
    try {
      final shiftId = data['shiftId'] as String;
      final action = data['action'] as String?;

      AppLogger.info('Attendance update: $shiftId ($action)');

      // Sync shifts to get updated attendance data
      await _shiftRepository.syncShifts();

      // Notify UI
      onShiftUpdated?.call();
    } catch (e) {
      AppLogger.error('Error handling attendance update', e);
    }
  }

  /// Handle location request from server
  Future<void> _handleLocationRequest(Map<String, dynamic> data) async {
    try {
      AppLogger.info('Location request received from server');
      // This is handled by the location tracking service
      // The server might request an immediate location update
    } catch (e) {
      AppLogger.error('Error handling location request', e);
    }
  }

  /// Handle general notification
  Future<void> _handleNotification(Map<String, dynamic> data) async {
    try {
      final title = data['title'] as String? ?? 'Notification';
      final body = data['body'] as String? ?? '';
      final notificationId = data['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString();

      AppLogger.info('Notification received: $title');

      await _notificationService.showGeneralNotification(
        id: notificationId.hashCode,
        title: title,
        body: body,
        payload: 'notification:$notificationId',
      );

      // Notify UI
      onNotification?.call(body);
    } catch (e) {
      AppLogger.error('Error handling notification', e);
    }
  }

  /// Dispose resources
  void dispose() {
    stopListening();
  }
}

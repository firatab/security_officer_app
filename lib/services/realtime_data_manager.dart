import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';
import '../data/repositories/shift_repository.dart';
import '../data/repositories/check_call_repository.dart';
import 'notification_service.dart';
import 'websocket_service.dart';

/// Real-time data state
class RealtimeDataState {
  final DateTime? lastShiftUpdate;
  final DateTime? lastAttendanceUpdate;
  final DateTime? lastCheckCallUpdate;
  final DateTime? lastIncidentUpdate;
  final bool hasNewNotification;
  final int pendingUpdates;

  const RealtimeDataState({
    this.lastShiftUpdate,
    this.lastAttendanceUpdate,
    this.lastCheckCallUpdate,
    this.lastIncidentUpdate,
    this.hasNewNotification = false,
    this.pendingUpdates = 0,
  });

  RealtimeDataState copyWith({
    DateTime? lastShiftUpdate,
    DateTime? lastAttendanceUpdate,
    DateTime? lastCheckCallUpdate,
    DateTime? lastIncidentUpdate,
    bool? hasNewNotification,
    int? pendingUpdates,
  }) {
    return RealtimeDataState(
      lastShiftUpdate: lastShiftUpdate ?? this.lastShiftUpdate,
      lastAttendanceUpdate: lastAttendanceUpdate ?? this.lastAttendanceUpdate,
      lastCheckCallUpdate: lastCheckCallUpdate ?? this.lastCheckCallUpdate,
      lastIncidentUpdate: lastIncidentUpdate ?? this.lastIncidentUpdate,
      hasNewNotification: hasNewNotification ?? this.hasNewNotification,
      pendingUpdates: pendingUpdates ?? this.pendingUpdates,
    );
  }
}

/// Manages real-time data synchronization from WebSocket events
class RealtimeDataManager extends StateNotifier<RealtimeDataState> {
  final WebSocketController _wsController;
  final AppDatabase _database;
  final ShiftRepository _shiftRepository;
  final CheckCallRepository _checkCallRepository;
  final NotificationService _notificationService;

  final List<StreamSubscription> _subscriptions = [];

  // Callbacks for UI refresh
  Function()? onShiftsUpdated;
  Function()? onAttendanceUpdated;
  Function()? onCheckCallUpdated;
  Function()? onIncidentUpdated;
  Function(Map<String, dynamic>)? onPanicAlert;
  Function(String title, String body)? onNotification;

  RealtimeDataManager({
    required WebSocketController wsController,
    required AppDatabase database,
    required ShiftRepository shiftRepository,
    required CheckCallRepository checkCallRepository,
    required NotificationService notificationService,
  })  : _wsController = wsController,
        _database = database,
        _shiftRepository = shiftRepository,
        _checkCallRepository = checkCallRepository,
        _notificationService = notificationService,
        super(const RealtimeDataState()) {
    _startListening();
  }

  /// Start listening to WebSocket event streams
  void _startListening() {
    // Listen to shift updates
    _subscriptions.add(_wsController.shiftUpdates.listen(_handleShiftUpdate));

    // Listen to check call updates
    _subscriptions.add(_wsController.checkCallUpdates.listen(_handleCheckCallUpdate));

    // Listen to incident updates
    _subscriptions.add(_wsController.incidentUpdates.listen(_handleIncidentUpdate));

    // Listen to panic alerts (high priority)
    _subscriptions.add(_wsController.panicAlerts.listen(_handlePanicAlert));

    // Listen to notifications
    _subscriptions.add(_wsController.notifications.listen(_handleNotification));

    AppLogger.info('RealtimeDataManager started listening to WebSocket events');
  }

  /// Handle shift-related updates (shift created/updated/deleted, attendance)
  Future<void> _handleShiftUpdate(Map<String, dynamic> data) async {
    try {
      final eventType = data['_eventType'] as String?;
      AppLogger.info('Handling shift update: $eventType');

      switch (eventType) {
        case SocketEvent.shiftCreated:
        case SocketEvent.shiftUpdated:
          // Sync shifts from server to get the latest data
          await _shiftRepository.syncShifts();
          break;

        case SocketEvent.shiftDeleted:
          // Remove the shift from local database
          final shiftId = data['shiftId'] as String?;
          if (shiftId != null) {
            await (_database.delete(_database.shifts)
                  ..where((tbl) => tbl.id.equals(shiftId)))
                .go();
          }
          break;

        case SocketEvent.attendanceBookOn:
        case SocketEvent.attendanceBookOff:
        case SocketEvent.attendanceUpdated:
          // Sync to get updated attendance data
          await _shiftRepository.syncShifts();
          state = state.copyWith(lastAttendanceUpdate: DateTime.now());
          onAttendanceUpdated?.call();
          break;
      }

      state = state.copyWith(lastShiftUpdate: DateTime.now());
      onShiftsUpdated?.call();
    } catch (e) {
      AppLogger.error('Error handling shift update', e);
    }
  }

  /// Handle check call updates
  Future<void> _handleCheckCallUpdate(Map<String, dynamic> data) async {
    try {
      final eventType = data['_eventType'] as String?;
      AppLogger.info('Handling check call update: $eventType');

      switch (eventType) {
        case SocketEvent.checkCallCreated:
          // A new check call is due - show notification
          final checkCallId = data['checkCallId'] as String?;
          final siteName = data['siteName'] as String? ?? 'your site';

          if (checkCallId != null) {
            await _notificationService.showCheckCallNotification(
              checkCallId: checkCallId,
              siteName: siteName,
              message: 'Check call required now! Please respond.',
            );
          }
          break;

        case SocketEvent.checkCallMissed:
          // Mark the check call as missed locally
          final checkCallId = data['checkCallId'] as String?;
          if (checkCallId != null) {
            await _checkCallRepository.markCheckCallMissed(checkCallId);
            await _notificationService.showGeneralNotification(
              id: checkCallId.hashCode,
              title: 'Check Call Missed',
              body: 'You missed a check call. Please contact your supervisor.',
              payload: 'check_call_missed:$checkCallId',
            );
          }
          break;

        case SocketEvent.checkCallAlert:
          // Reminder alert for upcoming check call
          final checkCallId = data['checkCallId'] as String?;
          final minutesUntil = data['minutesUntil'] as int? ?? 5;

          if (checkCallId != null) {
            await _notificationService.showGeneralNotification(
              id: checkCallId.hashCode + 1,
              title: 'Check Call Reminder',
              body: 'Check call due in $minutesUntil minutes.',
              payload: 'check_call_reminder:$checkCallId',
            );
          }
          break;
      }

      state = state.copyWith(lastCheckCallUpdate: DateTime.now());
      onCheckCallUpdated?.call();
    } catch (e) {
      AppLogger.error('Error handling check call update', e);
    }
  }

  /// Handle incident updates
  Future<void> _handleIncidentUpdate(Map<String, dynamic> data) async {
    try {
      final eventType = data['_eventType'] as String?;
      AppLogger.info('Handling incident update: $eventType');

      // For incidents, just notify the UI to refresh
      // The actual data will be fetched from the server
      state = state.copyWith(lastIncidentUpdate: DateTime.now());
      onIncidentUpdated?.call();

      // Show notification for new incidents (if relevant to this user)
      if (eventType == SocketEvent.incidentCreated) {
        final siteName = data['siteName'] as String? ?? 'a site';
        final incidentType = data['incidentType'] as String? ?? 'Incident';

        await _notificationService.showGeneralNotification(
          id: DateTime.now().millisecondsSinceEpoch,
          title: 'New Incident Reported',
          body: '$incidentType reported at $siteName',
          payload: 'incident:${data['id']}',
        );
      }
    } catch (e) {
      AppLogger.error('Error handling incident update', e);
    }
  }

  /// Handle panic alerts - highest priority
  Future<void> _handlePanicAlert(Map<String, dynamic> data) async {
    try {
      final eventType = data['_eventType'] as String?;
      AppLogger.info('PANIC ALERT received: $eventType');

      if (eventType == SocketEvent.panicAlert) {
        final siteName = data['site']?['name'] as String? ?? 'Unknown Site';
        final reporterName = data['reporterName'] as String? ?? 'Unknown';
        final incidentId = data['incidentId'] as String?;

        // Show high-priority notification
        await _notificationService.showGeneralNotification(
          id: incidentId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
          title: 'PANIC ALERT',
          body: '$reporterName triggered panic alert at $siteName',
          payload: 'panic_alert:$incidentId',
        );

        // Notify UI immediately
        onPanicAlert?.call(data);
      }
    } catch (e) {
      AppLogger.error('Error handling panic alert', e);
    }
  }

  /// Handle general notifications
  Future<void> _handleNotification(Map<String, dynamic> data) async {
    try {
      final title = data['title'] as String? ?? 'Notification';
      final body = data['body'] as String? ?? '';
      final notificationId = data['id'] as String?;

      await _notificationService.showGeneralNotification(
        id: notificationId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: body,
        payload: 'notification:$notificationId',
      );

      state = state.copyWith(hasNewNotification: true);
      onNotification?.call(title, body);
    } catch (e) {
      AppLogger.error('Error handling notification', e);
    }
  }

  /// Clear the new notification flag
  void clearNewNotificationFlag() {
    state = state.copyWith(hasNewNotification: false);
  }

  /// Force refresh all data from server
  Future<void> refreshAllData() async {
    try {
      state = state.copyWith(pendingUpdates: 1);

      await _shiftRepository.syncShifts();

      state = state.copyWith(
        lastShiftUpdate: DateTime.now(),
        lastAttendanceUpdate: DateTime.now(),
        pendingUpdates: 0,
      );

      onShiftsUpdated?.call();
      onAttendanceUpdated?.call();
    } catch (e) {
      AppLogger.error('Error refreshing all data', e);
      state = state.copyWith(pendingUpdates: 0);
    }
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }
}

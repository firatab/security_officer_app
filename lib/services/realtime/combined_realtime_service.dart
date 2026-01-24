import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/logger.dart';
import '../websocket_service.dart';
import 'appsync_config.dart';
import 'appsync_service.dart';

/// Combined Real-Time Event
///
/// Unifies events from both Socket.io and AppSync sources
class CombinedRealtimeEvent {
  final String source; // 'socket' or 'appsync'
  final String eventType;
  final String eventId;
  final Map<String, dynamic> data;
  final DateTime receivedAt;

  CombinedRealtimeEvent({
    required this.source,
    required this.eventType,
    required this.eventId,
    required this.data,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  @override
  String toString() => 'CombinedEvent($source: $eventType)';
}

/// Combined Real-Time State
class CombinedRealtimeState {
  final bool socketConnected;
  final bool appSyncConnected;
  final String? socketError;
  final String? appSyncError;
  final DateTime? lastEventAt;

  CombinedRealtimeState({
    this.socketConnected = false,
    this.appSyncConnected = false,
    this.socketError,
    this.appSyncError,
    this.lastEventAt,
  });

  bool get isAnyConnected => socketConnected || appSyncConnected;
  bool get isAllConnected => socketConnected && appSyncConnected;
  bool get hasError => socketError != null || appSyncError != null;

  CombinedRealtimeState copyWith({
    bool? socketConnected,
    bool? appSyncConnected,
    String? socketError,
    String? appSyncError,
    DateTime? lastEventAt,
  }) {
    return CombinedRealtimeState(
      socketConnected: socketConnected ?? this.socketConnected,
      appSyncConnected: appSyncConnected ?? this.appSyncConnected,
      socketError: socketError,
      appSyncError: appSyncError,
      lastEventAt: lastEventAt ?? this.lastEventAt,
    );
  }
}

/// Combined Real-Time Service
///
/// Manages both Socket.io and AppSync connections based on feature flags.
/// Provides unified event streams for the rest of the app.
class CombinedRealtimeController extends StateNotifier<CombinedRealtimeState> {
  final Ref _ref;

  // Event stream controllers
  final _attendanceController = StreamController<CombinedRealtimeEvent>.broadcast();
  final _shiftController = StreamController<CombinedRealtimeEvent>.broadcast();
  final _incidentController = StreamController<CombinedRealtimeEvent>.broadcast();
  final _panicController = StreamController<CombinedRealtimeEvent>.broadcast();
  final _checkCallController = StreamController<CombinedRealtimeEvent>.broadcast();
  final _allEventsController = StreamController<CombinedRealtimeEvent>.broadcast();

  // Public streams
  Stream<CombinedRealtimeEvent> get attendanceEvents => _attendanceController.stream;
  Stream<CombinedRealtimeEvent> get shiftEvents => _shiftController.stream;
  Stream<CombinedRealtimeEvent> get incidentEvents => _incidentController.stream;
  Stream<CombinedRealtimeEvent> get panicEvents => _panicController.stream;
  Stream<CombinedRealtimeEvent> get checkCallEvents => _checkCallController.stream;
  Stream<CombinedRealtimeEvent> get allEvents => _allEventsController.stream;

  // Subscriptions
  final List<StreamSubscription> _subscriptions = [];

  CombinedRealtimeController(this._ref) : super(CombinedRealtimeState()) {
    _initialize();
  }

  void _initialize() {
    AppLogger.info('[CombinedRealtime] Initializing with config: ${AppSyncConfig.toMap()}');

    // Setup Socket.io if enabled
    if (AppSyncConfig.isSocketEnabled) {
      _setupSocketListeners();
    }

    // Setup AppSync if enabled
    if (AppSyncConfig.isAppSyncEnabled) {
      _setupAppSyncListeners();
    }
  }

  void _setupSocketListeners() {
    final webSocket = _ref.read(webSocketProvider.notifier);

    // Listen to socket state
    _ref.listen<WebSocketState>(webSocketProvider, (previous, next) {
      state = state.copyWith(
        socketConnected: next.isConnected,
        socketError: next.errorMessage,
      );
    });

    // Listen to socket events
    _subscriptions.add(
      webSocket.shiftUpdates.listen((data) {
        _handleSocketEvent('shift', data);
      }),
    );

    _subscriptions.add(
      webSocket.checkCallUpdates.listen((data) {
        _handleSocketEvent('checkCall', data);
      }),
    );

    _subscriptions.add(
      webSocket.incidentUpdates.listen((data) {
        _handleSocketEvent('incident', data);
      }),
    );

    _subscriptions.add(
      webSocket.panicAlerts.listen((data) {
        _handleSocketEvent('panic', data);
      }),
    );

    _subscriptions.add(
      webSocket.notifications.listen((data) {
        // Route attendance-related notifications
        final eventType = data['_eventType'] as String?;
        if (eventType != null && eventType.startsWith('attendance:')) {
          _handleSocketEvent('attendance', data);
        }
      }),
    );

    AppLogger.info('[CombinedRealtime] Socket.io listeners configured');
  }

  void _setupAppSyncListeners() {
    final appSync = _ref.read(appSyncProvider.notifier);

    // Listen to AppSync state
    _ref.listen<AppSyncState>(appSyncProvider, (previous, next) {
      state = state.copyWith(
        appSyncConnected: next.isConnected,
        appSyncError: next.errorMessage,
      );
    });

    // Listen to AppSync events
    _subscriptions.add(
      appSync.attendanceEvents.listen((event) {
        _handleAppSyncEvent('attendance', event);
      }),
    );

    _subscriptions.add(
      appSync.shiftEvents.listen((event) {
        _handleAppSyncEvent('shift', event);
      }),
    );

    _subscriptions.add(
      appSync.incidentEvents.listen((event) {
        _handleAppSyncEvent('incident', event);
      }),
    );

    _subscriptions.add(
      appSync.panicEvents.listen((event) {
        _handleAppSyncEvent('panic', event);
      }),
    );

    _subscriptions.add(
      appSync.checkCallEvents.listen((event) {
        _handleAppSyncEvent('checkCall', event);
      }),
    );

    AppLogger.info('[CombinedRealtime] AppSync listeners configured');
  }

  void _handleSocketEvent(String type, Map<String, dynamic> data) {
    final eventId = data['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
    final eventType = data['_eventType']?.toString() ?? type;

    final event = CombinedRealtimeEvent(
      source: 'socket',
      eventType: eventType,
      eventId: eventId,
      data: data,
    );

    _routeEvent(type, event);
  }

  void _handleAppSyncEvent(String type, AppSyncEvent appSyncEvent) {
    final event = CombinedRealtimeEvent(
      source: 'appsync',
      eventType: appSyncEvent.eventType,
      eventId: appSyncEvent.eventId,
      data: appSyncEvent.data,
    );

    _routeEvent(type, event);
  }

  void _routeEvent(String type, CombinedRealtimeEvent event) {
    state = state.copyWith(lastEventAt: DateTime.now());

    // Add to all events stream
    _allEventsController.add(event);

    // Route to specific stream
    switch (type) {
      case 'attendance':
        _attendanceController.add(event);
        break;
      case 'shift':
        _shiftController.add(event);
        break;
      case 'incident':
        _incidentController.add(event);
        break;
      case 'panic':
        _panicController.add(event);
        break;
      case 'checkCall':
        _checkCallController.add(event);
        break;
    }

    AppLogger.debug('[CombinedRealtime] Routed ${event.source} event: $type');
  }

  /// Connect to all enabled realtime sources
  Future<void> connect() async {
    if (AppSyncConfig.isSocketEnabled) {
      await _ref.read(webSocketProvider.notifier).connect();
    }

    if (AppSyncConfig.isAppSyncEnabled) {
      await _ref.read(appSyncProvider.notifier).connect();
    }
  }

  /// Disconnect from all realtime sources
  Future<void> disconnect() async {
    if (AppSyncConfig.isSocketEnabled) {
      await _ref.read(webSocketProvider.notifier).disconnect();
    }

    if (AppSyncConfig.isAppSyncEnabled) {
      await _ref.read(appSyncProvider.notifier).disconnect();
    }
  }

  /// Reconnect all enabled sources
  void reconnect() {
    if (AppSyncConfig.isSocketEnabled) {
      _ref.read(webSocketProvider.notifier).reconnect();
    }

    if (AppSyncConfig.isAppSyncEnabled) {
      _ref.read(appSyncProvider.notifier).reconnect();
    }
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();

    _attendanceController.close();
    _shiftController.close();
    _incidentController.close();
    _panicController.close();
    _checkCallController.close();
    _allEventsController.close();

    super.dispose();
  }
}

/// Provider for combined realtime service
final combinedRealtimeProvider =
    StateNotifierProvider<CombinedRealtimeController, CombinedRealtimeState>((ref) {
  return CombinedRealtimeController(ref);
});

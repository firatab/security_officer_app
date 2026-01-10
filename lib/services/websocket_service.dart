import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';

/// WebSocket connection state
enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// Socket.IO event types (matching server events)
class SocketEvent {
  // Authentication
  static const String tokenRefresh = 'token:refresh';
  static const String tokenRefreshed = 'token:refreshed';

  // Connection
  static const String connectionEstablished = 'connection:established';
  static const String reconnectRequired = 'reconnect:required';

  // Presence
  static const String presenceUpdate = 'presence:update';
  static const String presenceChanged = 'presence:changed';
  static const String userOnline = 'user:online';
  static const String userOffline = 'user:offline';

  // Shift events
  static const String shiftCreated = 'shift:created';
  static const String shiftUpdated = 'shift:updated';
  static const String shiftDeleted = 'shift:deleted';

  // Attendance events
  static const String attendanceBookOn = 'attendance:book_on';
  static const String attendanceBookOff = 'attendance:book_off';
  static const String attendanceUpdated = 'attendance:updated';

  // Check call events
  static const String checkCallCreated = 'check_call:created';
  static const String checkCallMissed = 'check_call:missed';
  static const String checkCallAlert = 'check_call:alert';
  static const String checkCallAlarm = 'check_call_alarm';  // Alarm when check call is due
  static const String checkCallUpcoming = 'check_call_upcoming';  // Advance notice
  static const String checkCallDue = 'check_call_due';  // Push notification event

  // Incident events
  static const String incidentCreated = 'incident:created';
  static const String incidentUpdated = 'incident:updated';
  static const String incidentDeleted = 'incident:deleted';

  // Location events
  static const String locationUpdate = 'location:update';
  static const String geofenceEnter = 'geofence:enter';
  static const String geofenceExit = 'geofence:exit';

  // Patrol events
  static const String patrolStarted = 'patrol:started';
  static const String patrolCompleted = 'patrol:completed';
  static const String checkpointScanned = 'checkpoint:scanned';

  // Panic/Safety events
  static const String panicAlert = 'panic:alert';
  static const String panicAcknowledged = 'panic:acknowledged';
  static const String panicResolved = 'panic:resolved';

  // Offline sync
  static const String offlineSync = 'offline:sync';
  static const String offlineQueueCleared = 'offline:queue_cleared';

  // Push notifications
  static const String pushRegister = 'push:register';
  static const String pushNotification = 'push:notification';

  // Messages
  static const String messageEncrypted = 'message:encrypted';
  static const String messageReceived = 'message:received';

  // Background tasks
  static const String backgroundTask = 'background:task';
  static const String backgroundSync = 'background:sync';

  // Notifications
  static const String notificationNew = 'notification:new';
  static const String notificationRead = 'notification:read';
}

/// WebSocket message model
class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  WebSocketMessage({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] as String? ?? 'unknown',
      data: json['data'] as Map<String, dynamic>? ?? json,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
      };
}

/// WebSocket state
class WebSocketState {
  final WebSocketConnectionState connectionState;
  final String? errorMessage;
  final DateTime? lastConnected;
  final int reconnectAttempts;
  final Map<String, dynamic>? serverCapabilities;

  WebSocketState({
    this.connectionState = WebSocketConnectionState.disconnected,
    this.errorMessage,
    this.lastConnected,
    this.reconnectAttempts = 0,
    this.serverCapabilities,
  });

  WebSocketState copyWith({
    WebSocketConnectionState? connectionState,
    String? errorMessage,
    DateTime? lastConnected,
    int? reconnectAttempts,
    Map<String, dynamic>? serverCapabilities,
  }) {
    return WebSocketState(
      connectionState: connectionState ?? this.connectionState,
      errorMessage: errorMessage,
      lastConnected: lastConnected ?? this.lastConnected,
      reconnectAttempts: reconnectAttempts ?? this.reconnectAttempts,
      serverCapabilities: serverCapabilities ?? this.serverCapabilities,
    );
  }

  bool get isConnected => connectionState == WebSocketConnectionState.connected;
}

/// Socket.IO WebSocket service controller
class WebSocketController extends StateNotifier<WebSocketState> {
  IO.Socket? _socket;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Message stream controller for broadcasting messages to listeners
  final _messageController = StreamController<WebSocketMessage>.broadcast();
  Stream<WebSocketMessage> get messageStream => _messageController.stream;

  // Event-specific stream controllers
  final _shiftUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _checkCallController = StreamController<Map<String, dynamic>>.broadcast();
  final _incidentController = StreamController<Map<String, dynamic>>.broadcast();
  final _panicAlertController = StreamController<Map<String, dynamic>>.broadcast();
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get shiftUpdates => _shiftUpdateController.stream;
  Stream<Map<String, dynamic>> get checkCallUpdates => _checkCallController.stream;
  Stream<Map<String, dynamic>> get incidentUpdates => _incidentController.stream;
  Stream<Map<String, dynamic>> get panicAlerts => _panicAlertController.stream;
  Stream<Map<String, dynamic>> get notifications => _notificationController.stream;

  // Alias getters for PushNotificationService compatibility
  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;
  Stream<Map<String, dynamic>> get checkCallStream => _checkCallController.stream;
  Stream<Map<String, dynamic>> get incidentStream => _incidentController.stream;
  Stream<Map<String, dynamic>> get panicStream => _panicAlertController.stream;

  /// Check if connected
  bool get isConnected => state.isConnected;

  // Configuration
  static const int maxReconnectAttempts = 10;
  static const Duration pingInterval = Duration(seconds: 25);

  String? _employeeId;
  String? _tenantId;
  String? _currentToken;

  WebSocketController() : super(WebSocketState());

  /// Get device info for socket authentication
  Future<Map<String, String>> _getDeviceInfo() async {
    String deviceType = 'unknown';
    String deviceModel = 'unknown';
    String osVersion = 'unknown';

    try {
      if (Platform.isIOS) {
        deviceType = 'ios';
      } else if (Platform.isAndroid) {
        deviceType = 'android';
      }
      osVersion = Platform.operatingSystemVersion;
    } catch (e) {
      AppLogger.error('Error getting device info', e);
    }

    return {
      'deviceType': deviceType,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'appVersion': AppConstants.appVersion,
    };
  }

  /// Connect to Socket.IO server
  Future<void> connect() async {
    // Check if WebSocket is enabled
    if (!AppConstants.enableWebSocket) {
      AppLogger.info('WebSocket disabled - using HTTP polling instead');
      state = state.copyWith(
        connectionState: WebSocketConnectionState.disconnected,
        errorMessage: null,
      );
      return;
    }

    if (state.connectionState == WebSocketConnectionState.connecting ||
        state.connectionState == WebSocketConnectionState.connected) {
      return;
    }

    state = state.copyWith(
      connectionState: WebSocketConnectionState.connecting,
      errorMessage: null,
    );

    try {
      // Get authentication token
      _currentToken = await _storage.read(key: AppConstants.accessTokenKey);
      _employeeId = await _storage.read(key: AppConstants.employeeIdKey);
      _tenantId = await _storage.read(key: AppConstants.tenantIdKey);

      if (_currentToken == null || _employeeId == null || _tenantId == null) {
        throw Exception('Not authenticated');
      }

      // Get device info
      final deviceInfo = await _getDeviceInfo();
      final deviceId = await _getOrCreateDeviceId();

      // Build Socket.IO URL (should point to /api/socket path)
      final wsUrl = AppConstants.wsUrl;
      AppLogger.info('Connecting to Socket.IO: $wsUrl');

      // Create Socket.IO connection
      _socket = IO.io(
        wsUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling']) // Fallback to polling
            .setPath('/api/socket')
            .setAuth({
              'token': _currentToken,
              'deviceId': deviceId,
              'deviceType': deviceInfo['deviceType'],
              'deviceModel': deviceInfo['deviceModel'],
              'osVersion': deviceInfo['osVersion'],
              'appVersion': deviceInfo['appVersion'],
            })
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(maxReconnectAttempts)
            .setReconnectionDelay(5000)
            .setReconnectionDelayMax(30000)
            .build(),
      );

      _setupEventHandlers();

      AppLogger.info('Socket.IO connecting...');
    } catch (e) {
      AppLogger.error('Socket.IO connection failed', e);
      state = state.copyWith(
        connectionState: WebSocketConnectionState.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Get or create a unique device ID
  Future<String> _getOrCreateDeviceId() async {
    String? deviceId = await _storage.read(key: 'device_id');
    if (deviceId == null) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await _storage.write(key: 'device_id', value: deviceId);
    }
    return deviceId;
  }

  /// Setup Socket.IO event handlers
  void _setupEventHandlers() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      AppLogger.info('Socket.IO connected');
      state = state.copyWith(
        connectionState: WebSocketConnectionState.connected,
        lastConnected: DateTime.now(),
        reconnectAttempts: 0,
        errorMessage: null,
      );
    });

    _socket!.onDisconnect((reason) {
      AppLogger.info('Socket.IO disconnected: $reason');
      if (reason == 'io server disconnect') {
        state = state.copyWith(
          connectionState: WebSocketConnectionState.disconnected,
        );
      } else {
        state = state.copyWith(
          connectionState: WebSocketConnectionState.reconnecting,
        );
      }
    });

    _socket!.onConnectError((error) {
      AppLogger.error('Socket.IO connection error: $error');
      state = state.copyWith(
        connectionState: WebSocketConnectionState.error,
        errorMessage: error.toString(),
      );
    });

    _socket!.onReconnect((attemptNumber) {
      AppLogger.info('Socket.IO reconnected after $attemptNumber attempts');
      state = state.copyWith(
        connectionState: WebSocketConnectionState.connected,
        reconnectAttempts: 0,
      );
    });

    _socket!.onReconnectAttempt((attemptNumber) {
      AppLogger.info('Socket.IO reconnect attempt: $attemptNumber');
      state = state.copyWith(
        connectionState: WebSocketConnectionState.reconnecting,
        reconnectAttempts: attemptNumber,
      );
    });

    _socket!.onReconnectFailed((_) {
      AppLogger.error('Socket.IO reconnection failed');
      state = state.copyWith(
        connectionState: WebSocketConnectionState.error,
        errorMessage: 'Reconnection failed after max attempts',
      );
    });

    // Server events
    _socket!.on(SocketEvent.connectionEstablished, (data) {
      AppLogger.info('Connection established with server');
      if (data is Map<String, dynamic>) {
        state = state.copyWith(serverCapabilities: data['capabilities']);
      }
    });

    // Token refresh
    _socket!.on(SocketEvent.tokenRefreshed, (data) async {
      if (data is Map<String, dynamic> && data['token'] != null) {
        AppLogger.info('Token refreshed via socket');
        _currentToken = data['token'];
        await _storage.write(key: AppConstants.accessTokenKey, value: data['token']);
      }
    });

    // Shift events
    _socket!.on(SocketEvent.shiftCreated, (data) => _handleEvent(SocketEvent.shiftCreated, data, _shiftUpdateController));
    _socket!.on(SocketEvent.shiftUpdated, (data) => _handleEvent(SocketEvent.shiftUpdated, data, _shiftUpdateController));
    _socket!.on(SocketEvent.shiftDeleted, (data) => _handleEvent(SocketEvent.shiftDeleted, data, _shiftUpdateController));

    // Attendance events
    _socket!.on(SocketEvent.attendanceBookOn, (data) => _handleEvent(SocketEvent.attendanceBookOn, data, _shiftUpdateController));
    _socket!.on(SocketEvent.attendanceBookOff, (data) => _handleEvent(SocketEvent.attendanceBookOff, data, _shiftUpdateController));
    _socket!.on(SocketEvent.attendanceUpdated, (data) => _handleEvent(SocketEvent.attendanceUpdated, data, _shiftUpdateController));

    // Check call events
    _socket!.on(SocketEvent.checkCallCreated, (data) => _handleEvent(SocketEvent.checkCallCreated, data, _checkCallController));
    _socket!.on(SocketEvent.checkCallMissed, (data) => _handleEvent(SocketEvent.checkCallMissed, data, _checkCallController));
    _socket!.on(SocketEvent.checkCallAlert, (data) => _handleEvent(SocketEvent.checkCallAlert, data, _checkCallController));
    _socket!.on(SocketEvent.checkCallAlarm, (data) => _handleEvent(SocketEvent.checkCallAlarm, data, _checkCallController));
    _socket!.on(SocketEvent.checkCallUpcoming, (data) => _handleEvent(SocketEvent.checkCallUpcoming, data, _checkCallController));
    _socket!.on(SocketEvent.checkCallDue, (data) => _handleEvent(SocketEvent.checkCallDue, data, _checkCallController));

    // Incident events
    _socket!.on(SocketEvent.incidentCreated, (data) => _handleEvent(SocketEvent.incidentCreated, data, _incidentController));
    _socket!.on(SocketEvent.incidentUpdated, (data) => _handleEvent(SocketEvent.incidentUpdated, data, _incidentController));
    _socket!.on(SocketEvent.incidentDeleted, (data) => _handleEvent(SocketEvent.incidentDeleted, data, _incidentController));

    // Panic alerts (critical)
    _socket!.on(SocketEvent.panicAlert, (data) => _handleEvent(SocketEvent.panicAlert, data, _panicAlertController));
    _socket!.on(SocketEvent.panicAcknowledged, (data) => _handleEvent(SocketEvent.panicAcknowledged, data, _panicAlertController));
    _socket!.on(SocketEvent.panicResolved, (data) => _handleEvent(SocketEvent.panicResolved, data, _panicAlertController));

    // Notifications
    _socket!.on(SocketEvent.notificationNew, (data) => _handleEvent(SocketEvent.notificationNew, data, _notificationController));
    _socket!.on(SocketEvent.pushNotification, (data) => _handleEvent(SocketEvent.pushNotification, data, _notificationController));

    // Ping/Pong for connection health
    _socket!.on('pong', (data) {
      AppLogger.debug('Received pong from server');
    });
  }

  /// Handle incoming events and broadcast to appropriate streams
  void _handleEvent(String eventType, dynamic data, StreamController<Map<String, dynamic>> controller) {
    try {
      AppLogger.debug('Socket event received: $eventType');

      final Map<String, dynamic> eventData = data is Map<String, dynamic>
          ? data
          : {'data': data};

      // Add event type to the data
      eventData['_eventType'] = eventType;
      eventData['_receivedAt'] = DateTime.now().toIso8601String();

      // Broadcast to specific stream
      controller.add(eventData);

      // Also broadcast to general message stream
      _messageController.add(WebSocketMessage(
        type: eventType,
        data: eventData,
      ));
    } catch (e) {
      AppLogger.error('Error handling socket event $eventType', e);
    }
  }

  /// Disconnect from Socket.IO server
  Future<void> disconnect() async {
    try {
      _socket?.disconnect();
      _socket?.dispose();
    } catch (e) {
      AppLogger.error('Error disconnecting Socket.IO', e);
    }

    _socket = null;
    state = WebSocketState();

    AppLogger.info('Socket.IO disconnected');
  }

  /// Emit event to server
  void emit(String event, [dynamic data]) {
    if (_socket == null || !state.isConnected) {
      AppLogger.warning('Cannot emit event: socket not connected');
      return;
    }

    try {
      _socket!.emit(event, data);
      AppLogger.debug('Socket event emitted: $event');
    } catch (e) {
      AppLogger.error('Error emitting socket event', e);
    }
  }

  /// Send location update
  void sendLocationUpdate(double latitude, double longitude) {
    emit(SocketEvent.presenceUpdate, {
      'status': 'active',
      'location': {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
      },
    });
  }

  /// Send check call response
  void sendCheckCallResponse(String checkCallId, String status, {String? notes}) {
    emit('check_call:respond', {
      'checkCallId': checkCallId,
      'status': status,
      'notes': notes,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Register push notification token
  Future<void> registerPushToken(String token, String platform) async {
    emit(SocketEvent.pushRegister, {
      'token': token,
      'platform': platform,
    });
  }

  /// Sync offline queue
  Future<void> syncOfflineQueue(List<Map<String, dynamic>> queue) async {
    if (queue.isEmpty) return;

    emit(SocketEvent.offlineSync, {
      'queue': queue,
    });
  }

  /// Request token refresh
  void requestTokenRefresh() {
    if (_currentToken != null) {
      emit(SocketEvent.tokenRefresh, {
        'token': _currentToken,
      });
    }
  }

  /// Send ping to check connection health
  void sendPing() {
    emit('ping');
  }

  /// Manual reconnect
  void reconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.connect();
      state = state.copyWith(connectionState: WebSocketConnectionState.reconnecting);
    } else {
      connect();
    }
  }

  @override
  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _messageController.close();
    _shiftUpdateController.close();
    _checkCallController.close();
    _incidentController.close();
    _panicAlertController.close();
    _notificationController.close();
    super.dispose();
  }
}

/// Provider for WebSocket service
final webSocketProvider = StateNotifierProvider<WebSocketController, WebSocketState>((ref) {
  return WebSocketController();
});

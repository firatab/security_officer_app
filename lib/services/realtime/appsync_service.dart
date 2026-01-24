import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';
import 'appsync_config.dart';
import 'graphql_operations.dart';

/// AppSync connection state
enum AppSyncConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// AppSync event model
class AppSyncEvent {
  final String id;
  final String tenantId;
  final String eventId;
  final String eventType;
  final int version;
  final DateTime createdAt;
  final String? correlationId;
  final Map<String, dynamic> data;

  AppSyncEvent({
    required this.id,
    required this.tenantId,
    required this.eventId,
    required this.eventType,
    required this.version,
    required this.createdAt,
    this.correlationId,
    required this.data,
  });

  factory AppSyncEvent.fromJson(Map<String, dynamic> json) {
    return AppSyncEvent(
      id: json['id'] as String? ?? '',
      tenantId: json['tenantId'] as String? ?? '',
      eventId: json['eventId'] as String? ?? '',
      eventType: json['eventType'] as String? ?? '',
      version: json['version'] as int? ?? 1,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      correlationId: json['correlationId'] as String?,
      data: json,
    );
  }

  @override
  String toString() => 'AppSyncEvent(eventId: $eventId, type: $eventType)';
}

/// AppSync service state
class AppSyncState {
  final AppSyncConnectionState connectionState;
  final String? errorMessage;
  final DateTime? lastConnected;
  final int reconnectAttempts;

  AppSyncState({
    this.connectionState = AppSyncConnectionState.disconnected,
    this.errorMessage,
    this.lastConnected,
    this.reconnectAttempts = 0,
  });

  AppSyncState copyWith({
    AppSyncConnectionState? connectionState,
    String? errorMessage,
    DateTime? lastConnected,
    int? reconnectAttempts,
  }) {
    return AppSyncState(
      connectionState: connectionState ?? this.connectionState,
      errorMessage: errorMessage,
      lastConnected: lastConnected ?? this.lastConnected,
      reconnectAttempts: reconnectAttempts ?? this.reconnectAttempts,
    );
  }

  bool get isConnected => connectionState == AppSyncConnectionState.connected;
}

/// AppSync Service Controller
///
/// Manages WebSocket connections to AWS AppSync for real-time subscriptions.
class AppSyncController extends StateNotifier<AppSyncState> {
  WebSocketChannel? _channel;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Timer? _keepAliveTimer;
  Timer? _reconnectTimer;

  // Event stream controllers
  final _attendanceController = StreamController<AppSyncEvent>.broadcast();
  final _shiftController = StreamController<AppSyncEvent>.broadcast();
  final _incidentController = StreamController<AppSyncEvent>.broadcast();
  final _panicController = StreamController<AppSyncEvent>.broadcast();
  final _checkCallController = StreamController<AppSyncEvent>.broadcast();

  // Public streams
  Stream<AppSyncEvent> get attendanceEvents => _attendanceController.stream;
  Stream<AppSyncEvent> get shiftEvents => _shiftController.stream;
  Stream<AppSyncEvent> get incidentEvents => _incidentController.stream;
  Stream<AppSyncEvent> get panicEvents => _panicController.stream;
  Stream<AppSyncEvent> get checkCallEvents => _checkCallController.stream;

  // Deduplication cache
  final Map<String, DateTime> _processedEvents = {};

  // Current tenant ID
  String? _tenantId;
  String? _authToken;

  // Subscription IDs for tracking
  final Map<String, String> _subscriptionIds = {};

  AppSyncController() : super(AppSyncState());

  /// Check if event is duplicate
  bool _isEventDuplicate(String eventId) {
    final now = DateTime.now();

    // Clean old entries
    _processedEvents.removeWhere((id, timestamp) {
      return now.difference(timestamp).inMilliseconds > AppSyncConfig.eventCacheTtl;
    });

    if (_processedEvents.containsKey(eventId)) {
      return true;
    }

    _processedEvents[eventId] = now;
    return false;
  }

  /// Generate a unique subscription ID
  String _generateSubscriptionId() {
    return 'sub_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Connect to AppSync
  Future<void> connect() async {
    if (!AppSyncConfig.isAppSyncEnabled) {
      AppLogger.info('[AppSync] AppSync not enabled');
      return;
    }

    if (!AppSyncConfig.isConfigured) {
      AppLogger.warning('[AppSync] Not configured - missing endpoint');
      return;
    }

    if (state.connectionState == AppSyncConnectionState.connecting ||
        state.connectionState == AppSyncConnectionState.connected) {
      return;
    }

    state = state.copyWith(
      connectionState: AppSyncConnectionState.connecting,
      errorMessage: null,
    );

    try {
      // Get auth token
      _authToken = await _storage.read(key: AppConstants.accessTokenKey);
      _tenantId = await _storage.read(key: AppConstants.tenantIdKey);

      if (_authToken == null || _tenantId == null) {
        throw Exception('Not authenticated');
      }

      // Build WebSocket URL with auth
      final wsUrl = _buildWebSocketUrl();
      AppLogger.info('[AppSync] Connecting to: ${AppSyncConfig.realtimeEndpoint}');

      // Create WebSocket connection
      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['graphql-ws'],
      );

      // Listen to messages
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );

      // Send connection init
      _sendConnectionInit();

      state = state.copyWith(
        connectionState: AppSyncConnectionState.connected,
        lastConnected: DateTime.now(),
        reconnectAttempts: 0,
      );

      // Start keep-alive timer
      _startKeepAlive();

      // Subscribe to events
      _subscribeToEvents();

      AppLogger.info('[AppSync] Connected successfully');
    } catch (e) {
      AppLogger.error('[AppSync] Connection failed', e);
      state = state.copyWith(
        connectionState: AppSyncConnectionState.error,
        errorMessage: e.toString(),
      );
      _scheduleReconnect();
    }
  }

  /// Build WebSocket URL with authorization headers
  String _buildWebSocketUrl() {
    final endpoint = AppSyncConfig.realtimeEndpoint;

    // Build authorization header
    final Map<String, String> headers = {
      'host': Uri.parse(AppSyncConfig.graphqlEndpoint).host,
    };

    if (AppSyncConfig.useApiKeyAuth) {
      headers['x-api-key'] = AppSyncConfig.apiKey;
    } else {
      headers['Authorization'] = _authToken ?? '';
    }

    // Encode headers as base64
    final headerJson = jsonEncode(headers);
    final headerBase64 = base64Encode(utf8.encode(headerJson));

    // Build payload (empty for connection init)
    final payload = base64Encode(utf8.encode('{}'));

    return '$endpoint?header=$headerBase64&payload=$payload';
  }

  /// Send connection init message
  void _sendConnectionInit() {
    final message = {
      'type': 'connection_init',
    };
    _sendMessage(message);
  }

  /// Subscribe to all event types
  void _subscribeToEvents() {
    if (_tenantId == null) return;

    // Subscribe to attendance events
    _subscribe(
      'attendance',
      GraphQLOperations.onAttendanceEvent,
      {'tenantId': _tenantId},
    );

    // Subscribe to shift events
    _subscribe(
      'shift',
      GraphQLOperations.onShiftEvent,
      {'tenantId': _tenantId},
    );

    // Subscribe to incident events
    _subscribe(
      'incident',
      GraphQLOperations.onIncidentEvent,
      {'tenantId': _tenantId},
    );

    // Subscribe to panic events
    _subscribe(
      'panic',
      GraphQLOperations.onPanicEvent,
      {'tenantId': _tenantId},
    );

    // Subscribe to check call events
    _subscribe(
      'checkCall',
      GraphQLOperations.onCheckCallEvent,
      {'tenantId': _tenantId},
    );
  }

  /// Subscribe to a specific query
  void _subscribe(String name, String query, Map<String, dynamic> variables) {
    final subscriptionId = _generateSubscriptionId();
    _subscriptionIds[name] = subscriptionId;

    final message = {
      'id': subscriptionId,
      'type': 'start',
      'payload': {
        'data': jsonEncode({
          'query': query,
          'variables': variables,
        }),
        'extensions': {
          'authorization': AppSyncConfig.useApiKeyAuth
              ? {'x-api-key': AppSyncConfig.apiKey, 'host': Uri.parse(AppSyncConfig.graphqlEndpoint).host}
              : {'Authorization': _authToken, 'host': Uri.parse(AppSyncConfig.graphqlEndpoint).host},
        },
      },
    };

    _sendMessage(message);
    AppLogger.debug('[AppSync] Subscribed to $name with id: $subscriptionId');
  }

  /// Send message to WebSocket
  void _sendMessage(Map<String, dynamic> message) {
    if (_channel == null) return;
    _channel!.sink.add(jsonEncode(message));
  }

  /// Handle incoming message
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String?;

      switch (type) {
        case 'connection_ack':
          AppLogger.debug('[AppSync] Connection acknowledged');
          break;

        case 'ka':
          // Keep-alive received
          break;

        case 'data':
          _handleDataMessage(data);
          break;

        case 'error':
          AppLogger.error('[AppSync] Error message: ${data['payload']}');
          break;

        case 'complete':
          final id = data['id'] as String?;
          AppLogger.debug('[AppSync] Subscription complete: $id');
          break;
      }
    } catch (e) {
      AppLogger.error('[AppSync] Error handling message', e);
    }
  }

  /// Handle data message
  void _handleDataMessage(Map<String, dynamic> message) {
    final id = message['id'] as String?;
    final payload = message['payload'] as Map<String, dynamic>?;
    final data = payload?['data'] as Map<String, dynamic>?;

    if (data == null) return;

    // Find which subscription this belongs to
    String? subscriptionName;
    for (final entry in _subscriptionIds.entries) {
      if (entry.value == id) {
        subscriptionName = entry.key;
        break;
      }
    }

    if (subscriptionName == null) return;

    // Extract event data
    Map<String, dynamic>? eventData;
    switch (subscriptionName) {
      case 'attendance':
        eventData = data['onAttendanceEvent'] as Map<String, dynamic>?;
        break;
      case 'shift':
        eventData = data['onShiftEvent'] as Map<String, dynamic>?;
        break;
      case 'incident':
        eventData = data['onIncidentEvent'] as Map<String, dynamic>?;
        break;
      case 'panic':
        eventData = data['onPanicEvent'] as Map<String, dynamic>?;
        break;
      case 'checkCall':
        eventData = data['onCheckCallEvent'] as Map<String, dynamic>?;
        break;
    }

    if (eventData == null) return;

    final event = AppSyncEvent.fromJson(eventData);

    // Check for duplicates
    if (_isEventDuplicate(event.eventId)) {
      AppLogger.debug('[AppSync] Duplicate event ignored: ${event.eventId}');
      return;
    }

    AppLogger.info('[AppSync] Event received: $subscriptionName - ${event.eventType}');

    // Route to appropriate stream
    switch (subscriptionName) {
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
  }

  /// Handle WebSocket error
  void _handleError(dynamic error) {
    AppLogger.error('[AppSync] WebSocket error', error);
    state = state.copyWith(
      connectionState: AppSyncConnectionState.error,
      errorMessage: error.toString(),
    );
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnect
  void _handleDisconnect() {
    AppLogger.info('[AppSync] WebSocket disconnected');
    state = state.copyWith(connectionState: AppSyncConnectionState.disconnected);
    _stopKeepAlive();
    _scheduleReconnect();
  }

  /// Start keep-alive timer
  void _startKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(
      Duration(seconds: AppSyncConfig.keepAliveInterval),
      (_) {
        if (state.isConnected) {
          _sendMessage({'type': 'ka'});
        }
      },
    );
  }

  /// Stop keep-alive timer
  void _stopKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
  }

  /// Schedule reconnection
  void _scheduleReconnect() {
    if (state.reconnectAttempts >= AppSyncConfig.maxReconnectAttempts) {
      AppLogger.warning('[AppSync] Max reconnect attempts reached');
      return;
    }

    final delay = Duration(
      milliseconds: AppSyncConfig.reconnectDelay *
          (1 << state.reconnectAttempts).clamp(1, 32),
    );

    AppLogger.info('[AppSync] Reconnecting in ${delay.inSeconds}s (attempt ${state.reconnectAttempts + 1})');

    state = state.copyWith(
      connectionState: AppSyncConnectionState.reconnecting,
      reconnectAttempts: state.reconnectAttempts + 1,
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, connect);
  }

  /// Disconnect from AppSync
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _stopKeepAlive();

    // Unsubscribe from all subscriptions
    for (final id in _subscriptionIds.values) {
      _sendMessage({'id': id, 'type': 'stop'});
    }
    _subscriptionIds.clear();

    await _channel?.sink.close();
    _channel = null;

    state = AppSyncState();
    AppLogger.info('[AppSync] Disconnected');
  }

  /// Manual reconnect
  void reconnect() {
    state = state.copyWith(reconnectAttempts: 0);
    disconnect().then((_) => connect());
  }

  @override
  void dispose() {
    disconnect();
    _attendanceController.close();
    _shiftController.close();
    _incidentController.close();
    _panicController.close();
    _checkCallController.close();
    super.dispose();
  }
}

/// Provider for AppSync service
final appSyncProvider = StateNotifierProvider<AppSyncController, AppSyncState>((ref) {
  return AppSyncController();
});

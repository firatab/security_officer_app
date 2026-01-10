import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../core/network/dio_client.dart';
import '../core/utils/logger.dart';
import '../data/repositories/shift_repository.dart';
import 'notification_service.dart';

/// Polling state
class PollingState {
  final bool isPolling;
  final DateTime? lastPollTime;
  final int pollCount;
  final String? lastError;

  const PollingState({
    this.isPolling = false,
    this.lastPollTime,
    this.pollCount = 0,
    this.lastError,
  });

  PollingState copyWith({
    bool? isPolling,
    DateTime? lastPollTime,
    int? pollCount,
    String? lastError,
  }) {
    return PollingState(
      isPolling: isPolling ?? this.isPolling,
      lastPollTime: lastPollTime ?? this.lastPollTime,
      pollCount: pollCount ?? this.pollCount,
      lastError: lastError,
    );
  }
}

/// HTTP Polling service for real-time updates when WebSocket is not available
/// This is used as a fallback for AWS Amplify which doesn't support WebSocket
class PollingService extends StateNotifier<PollingState> {
  final DioClient _dioClient;
  final ShiftRepository _shiftRepository;
  final NotificationService _notificationService;

  Timer? _pollTimer;
  DateTime? _lastKnownShiftUpdate;
  DateTime? _lastKnownAttendanceUpdate;

  // Callbacks for data updates
  Function()? onShiftsUpdated;
  Function()? onAttendanceUpdated;
  Function()? onCheckCallAlert;
  Function(String title, String body)? onNotification;

  PollingService({
    required DioClient dioClient,
    required ShiftRepository shiftRepository,
    required NotificationService notificationService,
  })  : _dioClient = dioClient,
        _shiftRepository = shiftRepository,
        _notificationService = notificationService,
        super(const PollingState());

  /// Start polling for updates
  void startPolling() {
    if (state.isPolling) return;

    // Skip if WebSocket is enabled
    if (AppConstants.enableWebSocket) {
      AppLogger.info('Polling skipped - WebSocket is enabled');
      return;
    }

    state = state.copyWith(isPolling: true);
    _pollTimer?.cancel();

    // Poll immediately on start
    _poll();

    // Then poll at the configured interval
    _pollTimer = Timer.periodic(
      Duration(seconds: AppConstants.pollingIntervalSeconds),
      (_) => _poll(),
    );

    AppLogger.info('HTTP Polling started (interval: ${AppConstants.pollingIntervalSeconds}s)');
  }

  /// Stop polling
  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    state = state.copyWith(isPolling: false);
    AppLogger.info('HTTP Polling stopped');
  }

  /// Perform a single poll
  Future<void> _poll() async {
    try {
      AppLogger.debug('Polling for updates...');

      // Poll for shifts and attendance updates
      final shiftsUpdated = await _pollShifts();

      // Poll for check call alerts
      await _pollCheckCalls();

      // Poll for notifications
      await _pollNotifications();

      state = state.copyWith(
        lastPollTime: DateTime.now(),
        pollCount: state.pollCount + 1,
        lastError: null,
      );

      if (shiftsUpdated) {
        onShiftsUpdated?.call();
        onAttendanceUpdated?.call();
      }
    } catch (e) {
      AppLogger.error('Polling error', e);
      state = state.copyWith(lastError: e.toString());
    }
  }

  /// Poll for shift updates
  Future<bool> _pollShifts() async {
    try {
      // Sync shifts from server
      await _shiftRepository.syncShifts();

      // Check if there are any updates since last poll
      // For now, we just sync and notify
      return true;
    } catch (e) {
      AppLogger.error('Error polling shifts', e);
      return false;
    }
  }

  /// Poll for check call alerts
  Future<void> _pollCheckCalls() async {
    try {
      final response = await _dioClient.dio.get('/api/check-calls/pending');

      if (response.statusCode == 200 && response.data != null) {
        final checkCalls = response.data['checkCalls'] as List<dynamic>? ?? [];

        for (final checkCall in checkCalls) {
          final id = checkCall['id'] as String?;
          final siteName = checkCall['siteName'] as String? ?? 'your site';
          final status = checkCall['status'] as String?;

          if (status == 'pending' && id != null) {
            await _notificationService.showCheckCallNotification(
              checkCallId: id,
              siteName: siteName,
              message: 'Check call required now! Please respond.',
            );
            onCheckCallAlert?.call();
          }
        }
      }
    } catch (e) {
      // Silent fail - check calls might not have an endpoint yet
      AppLogger.debug('Check calls polling: ${e.toString()}');
    }
  }

  /// Poll for notifications
  Future<void> _pollNotifications() async {
    try {
      final response = await _dioClient.dio.get(
        '/api/mobile/notifications',
        queryParameters: {'unreadOnly': true, 'limit': 10},
      );

      if (response.statusCode == 200 && response.data != null) {
        final notifications = response.data['notifications'] as List<dynamic>? ?? [];

        for (final notification in notifications) {
          final id = notification['id'] as String?;
          final title = notification['title'] as String? ?? 'Notification';
          final body = notification['body'] as String? ?? '';
          final isRead = notification['isRead'] as bool? ?? false;

          if (!isRead && id != null) {
            await _notificationService.showGeneralNotification(
              id: id.hashCode,
              title: title,
              body: body,
              payload: 'notification:$id',
            );
            onNotification?.call(title, body);
          }
        }
      }
    } catch (e) {
      // Silent fail
      AppLogger.debug('Notifications polling: ${e.toString()}');
    }
  }

  /// Force an immediate poll
  Future<void> pollNow() async {
    await _poll();
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}

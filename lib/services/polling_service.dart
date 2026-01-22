import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/api_endpoints.dart';
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

  /// Poll for notifications
  Future<void> _pollNotifications() async {
    try {
      final since = state.lastPollTime?.toIso8601String();

      final response = await _dioClient.dio.get(
        ApiEndpoints.mobileNotifications,
        queryParameters: {
          if (since != null) 'since': since,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final notifications = response.data['data'] as List<dynamic>? ?? [];

        for (final notification in notifications) {
          if (notification is Map<String, dynamic>) {
            await _showMobileNotification(notification);
          }
        }
      }
    } catch (e) {
      // Silent fail
      AppLogger.debug('Notifications polling: ${e.toString()}');
    }
  }

  Future<void> _showMobileNotification(Map<String, dynamic> notification) async {
    final type = notification['type'] as String?;
    final id = notification['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();

    switch (type) {
      case 'new_job_assignment':
        final shiftData = notification['shift'] as Map<String, dynamic>?;
        if (shiftData == null) {
          return;
        }

        final shiftId = shiftData['id'] as String? ?? id;
        final siteName = shiftData['siteName'] as String? ?? 'Unknown Site';
        final startTimeStr = shiftData['startTime'] as String?;
        final startTime = DateTime.tryParse(startTimeStr ?? '') ?? DateTime.now();

        await _notificationService.showNewJobNotification(
          shiftId: shiftId,
          siteName: siteName,
          startTime: startTime,
        );

        final dateStr = '${startTime.day}/${startTime.month}/${startTime.year}';
        final timeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
        onNotification?.call(
          'New Job Assignment',
          'You have been assigned to $siteName on $dateStr at $timeStr.',
        );
        break;

      case 'check_call_reminder':
        final checkCallId = notification['checkCallId'] as String? ?? id;
        final siteName = notification['siteName'] as String? ?? 'your site';
        final message = notification['message'] as String? ?? 'Check call required now! Please respond.';

        await _notificationService.showCheckCallNotification(
          checkCallId: checkCallId,
          siteName: siteName,
          message: message,
        );
        onCheckCallAlert?.call();
        onNotification?.call('Check Call', message);
        break;

      case 'shift_update':
        final title = notification['title'] as String? ?? 'Shift Update';
        final message = notification['message'] as String? ?? 'Your shift has been updated.';

        await _notificationService.showGeneralNotification(
          id: id.hashCode,
          title: title,
          body: message,
          payload: 'notification:$id',
        );
        onNotification?.call(title, message);
        break;

      default:
        final title = notification['title'] as String? ?? 'Notification';
        final message = notification['message'] as String? ?? '';
        if (title.isEmpty && message.isEmpty) {
          return;
        }

        await _notificationService.showGeneralNotification(
          id: id.hashCode,
          title: title,
          body: message,
          payload: 'notification:$id',
        );
        onNotification?.call(title, message);
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

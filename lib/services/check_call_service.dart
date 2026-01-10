import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';
import '../data/repositories/check_call_repository.dart';
import 'location_service.dart';
import 'notification_service.dart';

/// Check call state
class CheckCallState {
  final bool isActive;
  final CheckCall? currentCheckCall;
  final CheckCall? nextCheckCall;
  final DateTime? nextCheckCallTime;
  final int answeredCount;
  final int missedCount;
  final int pendingCount;
  final String? error;

  CheckCallState({
    this.isActive = false,
    this.currentCheckCall,
    this.nextCheckCall,
    this.nextCheckCallTime,
    this.answeredCount = 0,
    this.missedCount = 0,
    this.pendingCount = 0,
    this.error,
  });

  CheckCallState copyWith({
    bool? isActive,
    CheckCall? currentCheckCall,
    CheckCall? nextCheckCall,
    DateTime? nextCheckCallTime,
    int? answeredCount,
    int? missedCount,
    int? pendingCount,
    String? error,
  }) {
    return CheckCallState(
      isActive: isActive ?? this.isActive,
      currentCheckCall: currentCheckCall ?? this.currentCheckCall,
      nextCheckCall: nextCheckCall ?? this.nextCheckCall,
      nextCheckCallTime: nextCheckCallTime ?? this.nextCheckCallTime,
      answeredCount: answeredCount ?? this.answeredCount,
      missedCount: missedCount ?? this.missedCount,
      pendingCount: pendingCount ?? this.pendingCount,
      error: error,
    );
  }

  CheckCallState clearCurrentCheckCall() {
    return CheckCallState(
      isActive: isActive,
      currentCheckCall: null,
      nextCheckCall: nextCheckCall,
      nextCheckCallTime: nextCheckCallTime,
      answeredCount: answeredCount,
      missedCount: missedCount,
      pendingCount: pendingCount,
      error: error,
    );
  }
}

/// Check call controller
class CheckCallController extends StateNotifier<CheckCallState> {
  final CheckCallRepository _repository;
  final LocationService _locationService;
  final NotificationService _notificationService;

  Timer? _checkTimer;
  String? _currentShiftId;
  String? _currentEmployeeId;
  String? _currentSiteName;

  // Grace period for check calls (5 minutes)
  static const int gracePeriodMinutes = 5;

  CheckCallController(
    this._repository,
    this._locationService,
    this._notificationService,
  ) : super(CheckCallState());

  /// Start monitoring check calls for a shift
  Future<void> startMonitoring({
    required String shiftId,
    required String employeeId,
    required String siteName,
  }) async {
    _currentShiftId = shiftId;
    _currentEmployeeId = employeeId;
    _currentSiteName = siteName;

    // Load initial stats
    await _refreshStats();

    // Start periodic check
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkForPendingCalls(),
    );

    // Initial check
    await _checkForPendingCalls();

    state = state.copyWith(isActive: true);
    AppLogger.info('Check call monitoring started for shift $shiftId');
  }

  /// Stop monitoring check calls
  Future<void> stopMonitoring() async {
    _checkTimer?.cancel();
    _checkTimer = null;

    // Cancel all scheduled notifications
    await _notificationService.cancelAllCheckCallNotifications();

    _currentShiftId = null;
    _currentEmployeeId = null;
    _currentSiteName = null;

    state = CheckCallState();
    AppLogger.info('Check call monitoring stopped');
  }

  /// Check for pending check calls that need attention
  Future<void> _checkForPendingCalls() async {
    if (_currentEmployeeId == null) return;

    try {
      final now = DateTime.now();
      final pendingCalls = await _repository.getPendingCheckCalls(_currentEmployeeId!);

      CheckCall? activeCall;
      CheckCall? nextCall;

      for (final call in pendingCalls) {
        final scheduledTime = call.scheduledTime;
        final gracePeriodEnd = scheduledTime.add(const Duration(minutes: gracePeriodMinutes));

        // Check if this call is currently active (within grace period)
        if (scheduledTime.isBefore(now) && gracePeriodEnd.isAfter(now)) {
          activeCall = call;
          break;
        }

        // Check if this call has been missed
        if (gracePeriodEnd.isBefore(now)) {
          await _repository.markCheckCallMissed(call.id);
          await _notificationService.cancelCheckCallNotification(call.id);
          continue;
        }

        // This is a future call
        if (nextCall == null && scheduledTime.isAfter(now)) {
          nextCall = call;
        }
      }

      // Update state
      state = state.copyWith(
        currentCheckCall: activeCall,
        nextCheckCall: nextCall,
        nextCheckCallTime: nextCall?.scheduledTime,
      );

      // Show notification if there's an active check call
      if (activeCall != null && state.currentCheckCall?.id != activeCall.id) {
        await _notificationService.showCheckCallNotification(
          checkCallId: activeCall.id,
          siteName: _currentSiteName ?? 'your site',
          message: 'Check call required! Please respond within $gracePeriodMinutes minutes.',
        );
      }

      // Schedule notification for next check call if not already scheduled
      if (nextCall != null) {
        await _notificationService.scheduleCheckCallNotification(
          checkCallId: nextCall.id,
          siteName: _currentSiteName ?? 'your site',
          scheduledTime: nextCall.scheduledTime,
        );
      }

      // Refresh stats
      await _refreshStats();
    } catch (e) {
      AppLogger.error('Error checking for pending calls', e);
      state = state.copyWith(error: 'Error checking check calls: $e');
    }
  }

  /// Refresh check call statistics
  Future<void> _refreshStats() async {
    if (_currentShiftId == null) return;

    try {
      final stats = await _repository.getCheckCallStats(_currentShiftId!);
      state = state.copyWith(
        answeredCount: stats['answered'] ?? 0,
        missedCount: stats['missed'] ?? 0,
        pendingCount: stats['pending'] ?? 0,
      );
    } catch (e) {
      AppLogger.error('Error refreshing stats', e);
    }
  }

  /// Respond to the current active check call
  Future<bool> respondToCurrentCheckCall({String? notes}) async {
    final currentCall = state.currentCheckCall;
    if (currentCall == null) {
      state = state.copyWith(error: 'No active check call to respond to');
      return false;
    }

    try {
      // Get current location
      final position = await _locationService.getCurrentLocation();

      // Respond to check call
      await _repository.respondToCheckCallOnline(
        checkCallId: currentCall.id,
        latitude: position.latitude,
        longitude: position.longitude,
        notes: notes,
      );

      // Cancel notification
      await _notificationService.cancelCheckCallNotification(currentCall.id);

      // Clear current check call and refresh
      state = state.clearCurrentCheckCall();
      await _checkForPendingCalls();

      AppLogger.info('Responded to check call: ${currentCall.id}');
      return true;
    } catch (e) {
      AppLogger.error('Error responding to check call', e);
      state = state.copyWith(error: 'Error responding to check call: $e');
      return false;
    }
  }

  /// Respond to a specific check call
  Future<bool> respondToCheckCall(String checkCallId, {String? notes}) async {
    try {
      // Get current location
      final position = await _locationService.getCurrentLocation();

      // Respond to check call
      await _repository.respondToCheckCallOnline(
        checkCallId: checkCallId,
        latitude: position.latitude,
        longitude: position.longitude,
        notes: notes,
      );

      // Cancel notification
      await _notificationService.cancelCheckCallNotification(checkCallId);

      // Refresh
      await _checkForPendingCalls();

      AppLogger.info('Responded to check call: $checkCallId');
      return true;
    } catch (e) {
      AppLogger.error('Error responding to check call', e);
      state = state.copyWith(error: 'Error responding to check call: $e');
      return false;
    }
  }

  /// Snooze the current check call for 5 minutes
  Future<void> snoozeCurrentCheckCall() async {
    final currentCall = state.currentCheckCall;
    if (currentCall == null) return;

    // Cancel current notification
    await _notificationService.cancelCheckCallNotification(currentCall.id);

    // Schedule a new notification in 5 minutes
    final snoozeTime = DateTime.now().add(const Duration(minutes: 5));
    await _notificationService.scheduleCheckCallNotification(
      checkCallId: currentCall.id,
      siteName: _currentSiteName ?? 'your site',
      scheduledTime: snoozeTime,
      message: 'Snoozed check call - please respond now!',
    );

    // Clear current check call temporarily
    state = state.clearCurrentCheckCall();

    AppLogger.info('Check call snoozed for 5 minutes: ${currentCall.id}');
  }

  /// Get all check calls for current shift
  Future<List<CheckCall>> getAllCheckCalls() async {
    if (_currentShiftId == null) return [];
    return await _repository.getCheckCallsForShift(_currentShiftId!);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }
}

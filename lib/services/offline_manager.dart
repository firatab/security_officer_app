import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';
import 'sync_service.dart';

/// Connectivity state
enum ConnectivityStatus {
  online,
  offline,
  syncing,
}

/// Offline manager state
class OfflineState {
  final ConnectivityStatus status;
  final int pendingOperations;
  final int failedOperations;
  final DateTime? lastSyncTime;
  final String? lastError;
  final bool isSyncing;

  OfflineState({
    this.status = ConnectivityStatus.offline,
    this.pendingOperations = 0,
    this.failedOperations = 0,
    this.lastSyncTime,
    this.lastError,
    this.isSyncing = false,
  });

  OfflineState copyWith({
    ConnectivityStatus? status,
    int? pendingOperations,
    int? failedOperations,
    DateTime? lastSyncTime,
    String? lastError,
    bool? isSyncing,
  }) {
    return OfflineState(
      status: status ?? this.status,
      pendingOperations: pendingOperations ?? this.pendingOperations,
      failedOperations: failedOperations ?? this.failedOperations,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      lastError: lastError,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }

  bool get isOnline => status == ConnectivityStatus.online;
  bool get hasUnsynced => pendingOperations > 0 || failedOperations > 0;
}

/// Offline manager controller
class OfflineManager extends StateNotifier<OfflineState> {
  final SyncService _syncService;
  final AppDatabase _database;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _syncTimer;
  Timer? _queueCheckTimer;

  // Sync configuration
  static const Duration syncInterval = Duration(minutes: 5);
  static const Duration queueCheckInterval = Duration(seconds: 30);

  OfflineManager(this._syncService, this._database) : super(OfflineState()) {
    _initialize();
  }

  /// Initialize the offline manager
  Future<void> _initialize() async {
    // Check initial connectivity
    await _checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );

    // Start periodic queue check
    _queueCheckTimer = Timer.periodic(queueCheckInterval, (_) {
      _updateQueueStatus();
    });

    // Initial queue status
    await _updateQueueStatus();

    AppLogger.info('Offline manager initialized');
  }

  /// Check current connectivity status
  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    await _onConnectivityChanged(result);
  }

  /// Handle connectivity changes
  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    final isConnected = results.isNotEmpty &&
        !results.contains(ConnectivityResult.none);

    final previousStatus = state.status;

    if (isConnected) {
      state = state.copyWith(status: ConnectivityStatus.online);

      // If we just came online, trigger sync
      if (previousStatus == ConnectivityStatus.offline) {
        AppLogger.info('Network restored - triggering sync');
        await syncNow();
      }

      // Start periodic sync timer
      _startSyncTimer();
    } else {
      state = state.copyWith(status: ConnectivityStatus.offline);
      _stopSyncTimer();
      AppLogger.info('Network lost - offline mode activated');
    }
  }

  /// Start periodic sync timer
  void _startSyncTimer() {
    _stopSyncTimer();
    _syncTimer = Timer.periodic(syncInterval, (_) {
      if (state.isOnline && !state.isSyncing) {
        syncNow();
      }
    });
  }

  /// Stop periodic sync timer
  void _stopSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Update queue status from database
  Future<void> _updateQueueStatus() async {
    try {
      final pendingItems = await _database.getPendingSyncItems();
      final failedItems = pendingItems.where((item) =>
          item.status == 'failed' || item.retryCount >= item.maxRetries).toList();
      final actualPending = pendingItems.where((item) =>
          item.status == 'pending' && item.retryCount < item.maxRetries).toList();

      // Also count unsynced location logs
      final unsyncedLogs = await _database.getUnsyncedLocationLogs(limit: 1000);

      state = state.copyWith(
        pendingOperations: actualPending.length + unsyncedLogs.length,
        failedOperations: failedItems.length,
      );
    } catch (e) {
      AppLogger.error('Error updating queue status', e);
    }
  }

  /// Trigger immediate sync
  Future<bool> syncNow() async {
    if (state.isSyncing) {
      AppLogger.debug('Sync already in progress');
      return false;
    }

    if (!state.isOnline) {
      AppLogger.debug('Cannot sync - offline');
      return false;
    }

    state = state.copyWith(
      isSyncing: true,
      status: ConnectivityStatus.syncing,
    );

    try {
      AppLogger.info('Starting sync...');

      // Process sync queue
      await _syncService.processSyncQueue();

      // Sync location logs
      await _syncService.syncLocationLogs();

      // Update queue status
      await _updateQueueStatus();

      state = state.copyWith(
        isSyncing: false,
        status: ConnectivityStatus.online,
        lastSyncTime: DateTime.now(),
        lastError: null,
      );

      AppLogger.info('Sync completed successfully');
      return true;
    } catch (e) {
      AppLogger.error('Sync failed', e);
      state = state.copyWith(
        isSyncing: false,
        status: ConnectivityStatus.online,
        lastError: e.toString(),
      );
      return false;
    }
  }

  /// Retry failed operations
  Future<void> retryFailedOperations() async {
    try {
      // Reset failed items to pending
      final pendingItems = await _database.getPendingSyncItems();
      for (final item in pendingItems) {
        if (item.status == 'failed') {
          await (_database.update(_database.syncQueue)
                ..where((tbl) => tbl.id.equals(item.id)))
              .write(const SyncQueueCompanion(
            status: drift.Value('pending'),
            retryCount: drift.Value(0),
          ));
        }
      }

      await _updateQueueStatus();

      // Trigger sync
      if (state.isOnline) {
        await syncNow();
      }
    } catch (e) {
      AppLogger.error('Error retrying failed operations', e);
    }
  }

  /// Clear all failed operations
  Future<void> clearFailedOperations() async {
    try {
      await (_database.delete(_database.syncQueue)
            ..where((tbl) => tbl.status.equals('failed')))
          .go();

      await _updateQueueStatus();
      AppLogger.info('Cleared failed operations');
    } catch (e) {
      AppLogger.error('Error clearing failed operations', e);
    }
  }

  /// Force offline mode (for testing)
  void forceOffline() {
    state = state.copyWith(status: ConnectivityStatus.offline);
    _stopSyncTimer();
  }

  /// Force online mode (for testing)
  void forceOnline() {
    state = state.copyWith(status: ConnectivityStatus.online);
    _startSyncTimer();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(lastError: null);
  }

  /// Schedule a sync - will sync immediately if online, otherwise wait for connectivity
  void scheduleSync() {
    if (state.isOnline && !state.isSyncing) {
      // Sync immediately if online
      syncNow();
    } else {
      // Sync will happen automatically when connectivity is restored
      AppLogger.debug('Sync scheduled - will sync when online');
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
    _queueCheckTimer?.cancel();
    super.dispose();
  }
}

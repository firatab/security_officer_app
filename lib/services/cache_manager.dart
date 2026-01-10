import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';

/// Cache manager for offline data management
class CacheManager {
  final AppDatabase _database;

  // Cache keys
  static const String lastShiftSyncKey = 'last_shift_sync';
  static const String lastCheckCallSyncKey = 'last_check_call_sync';
  static const String cacheVersionKey = 'cache_version';
  static const int currentCacheVersion = 1;

  // Cache durations
  static const Duration shiftCacheValidity = Duration(hours: 24);
  static const Duration checkCallCacheValidity = Duration(hours: 1);
  static const Duration locationLogRetention = Duration(days: 30);

  CacheManager(this._database);

  /// Check if shift cache is valid
  Future<bool> isShiftCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getInt(lastShiftSyncKey);

    if (lastSync == null) return false;

    final lastSyncTime = DateTime.fromMillisecondsSinceEpoch(lastSync);
    final now = DateTime.now();

    return now.difference(lastSyncTime) < shiftCacheValidity;
  }

  /// Update shift cache timestamp
  Future<void> updateShiftCacheTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastShiftSyncKey, DateTime.now().millisecondsSinceEpoch);
    AppLogger.debug('Updated shift cache timestamp');
  }

  /// Check if check call cache is valid
  Future<bool> isCheckCallCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getInt(lastCheckCallSyncKey);

    if (lastSync == null) return false;

    final lastSyncTime = DateTime.fromMillisecondsSinceEpoch(lastSync);
    final now = DateTime.now();

    return now.difference(lastSyncTime) < checkCallCacheValidity;
  }

  /// Update check call cache timestamp
  Future<void> updateCheckCallCacheTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastCheckCallSyncKey, DateTime.now().millisecondsSinceEpoch);
    AppLogger.debug('Updated check call cache timestamp');
  }

  /// Get cache statistics
  Future<CacheStats> getCacheStats() async {
    final shifts = await (_database.select(_database.shifts)).get();
    final attendances = await (_database.select(_database.attendances)).get();
    final locationLogs = await (_database.select(_database.locationLogs)).get();
    final checkCalls = await (_database.select(_database.checkCalls)).get();
    final syncQueue = await (_database.select(_database.syncQueue)).get();

    final prefs = await SharedPreferences.getInstance();
    final shiftSyncTime = prefs.getInt(lastShiftSyncKey);
    final checkCallSyncTime = prefs.getInt(lastCheckCallSyncKey);

    return CacheStats(
      shiftCount: shifts.length,
      attendanceCount: attendances.length,
      locationLogCount: locationLogs.length,
      checkCallCount: checkCalls.length,
      syncQueueCount: syncQueue.length,
      lastShiftSync: shiftSyncTime != null
          ? DateTime.fromMillisecondsSinceEpoch(shiftSyncTime)
          : null,
      lastCheckCallSync: checkCallSyncTime != null
          ? DateTime.fromMillisecondsSinceEpoch(checkCallSyncTime)
          : null,
    );
  }

  /// Clear old location logs
  Future<int> clearOldLocationLogs() async {
    final cutoffDate = DateTime.now().subtract(locationLogRetention);

    final deleted = await (_database.delete(_database.locationLogs)
          ..where((tbl) => tbl.needsSync.equals(false))
          ..where((tbl) => tbl.timestamp.isSmallerOrEqual(Variable(cutoffDate))))
        .go();

    AppLogger.info('Cleared $deleted old location logs');
    return deleted;
  }

  /// Clear all completed sync items older than a week
  Future<int> clearOldSyncItems() async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 7));

    final deleted = await (_database.delete(_database.syncQueue)
          ..where((tbl) => tbl.status.isIn(['completed', 'failed']))
          ..where((tbl) => tbl.createdAt.isSmallerOrEqual(Variable(cutoffDate))))
        .go();

    AppLogger.info('Cleared $deleted old sync items');
    return deleted;
  }

  /// Perform full cache cleanup
  Future<CacheCleanupResult> performCleanup() async {
    AppLogger.info('Starting cache cleanup...');

    final locationLogsDeleted = await clearOldLocationLogs();
    final syncItemsDeleted = await clearOldSyncItems();

    // Clear old shifts (keep last 60 days)
    final shiftCutoff = DateTime.now().subtract(const Duration(days: 60));
    final shiftsDeleted = await (_database.delete(_database.shifts)
          ..where((tbl) => tbl.shiftDate.isSmallerOrEqual(Variable(shiftCutoff))))
        .go();

    // Clear orphaned attendances
    final allShiftIds = (await (_database.select(_database.shifts)).get())
        .map((s) => s.id)
        .toList();

    int attendancesDeleted = 0;
    if (allShiftIds.isNotEmpty) {
      attendancesDeleted = await (_database.delete(_database.attendances)
            ..where((tbl) => tbl.shiftId.isNotIn(allShiftIds)))
          .go();
    }

    AppLogger.info('Cache cleanup completed');

    return CacheCleanupResult(
      locationLogsDeleted: locationLogsDeleted,
      syncItemsDeleted: syncItemsDeleted,
      shiftsDeleted: shiftsDeleted,
      attendancesDeleted: attendancesDeleted,
    );
  }

  /// Clear all cached data (for logout)
  Future<void> clearAllCache() async {
    AppLogger.info('Clearing all cached data...');

    await _database.clearAllData();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(lastShiftSyncKey);
    await prefs.remove(lastCheckCallSyncKey);

    AppLogger.info('All cached data cleared');
  }

  /// Check and migrate cache if needed
  Future<void> checkCacheVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final version = prefs.getInt(cacheVersionKey) ?? 0;

    if (version < currentCacheVersion) {
      AppLogger.info('Migrating cache from version $version to $currentCacheVersion');
      // Perform any necessary migrations here
      await prefs.setInt(cacheVersionKey, currentCacheVersion);
    }
  }

  /// Preload essential data for offline use
  Future<void> preloadOfflineData() async {
    AppLogger.info('Preloading offline data...');

    // This method can be called after login to ensure
    // essential data is cached for offline use

    // The actual data loading is handled by repositories
    // This is a hook for any additional preloading logic

    await checkCacheVersion();
    AppLogger.info('Offline data preload completed');
  }
}

/// Cache statistics
class CacheStats {
  final int shiftCount;
  final int attendanceCount;
  final int locationLogCount;
  final int checkCallCount;
  final int syncQueueCount;
  final DateTime? lastShiftSync;
  final DateTime? lastCheckCallSync;

  CacheStats({
    required this.shiftCount,
    required this.attendanceCount,
    required this.locationLogCount,
    required this.checkCallCount,
    required this.syncQueueCount,
    this.lastShiftSync,
    this.lastCheckCallSync,
  });

  int get totalCachedItems =>
      shiftCount + attendanceCount + locationLogCount + checkCallCount;

  bool get isShiftCacheStale {
    if (lastShiftSync == null) return true;
    return DateTime.now().difference(lastShiftSync!) >
        CacheManager.shiftCacheValidity;
  }

  bool get isCheckCallCacheStale {
    if (lastCheckCallSync == null) return true;
    return DateTime.now().difference(lastCheckCallSync!) >
        CacheManager.checkCallCacheValidity;
  }
}

/// Cache cleanup result
class CacheCleanupResult {
  final int locationLogsDeleted;
  final int syncItemsDeleted;
  final int shiftsDeleted;
  final int attendancesDeleted;

  CacheCleanupResult({
    required this.locationLogsDeleted,
    required this.syncItemsDeleted,
    required this.shiftsDeleted,
    required this.attendancesDeleted,
  });

  int get totalDeleted =>
      locationLogsDeleted + syncItemsDeleted + shiftsDeleted + attendancesDeleted;
}

import 'package:flutter_test/flutter_test.dart';
import 'package:security_officer_app/services/cache_manager.dart';

void main() {
  group('CacheStats', () {
    test('should calculate total cached items correctly', () {
      final stats = CacheStats(
        shiftCount: 10,
        attendanceCount: 5,
        locationLogCount: 100,
        checkCallCount: 20,
        syncQueueCount: 3,
      );

      expect(stats.totalCachedItems, equals(135));
    });

    test('should detect stale shift cache when null', () {
      final stats = CacheStats(
        shiftCount: 10,
        attendanceCount: 5,
        locationLogCount: 100,
        checkCallCount: 20,
        syncQueueCount: 3,
        lastShiftSync: null,
      );

      expect(stats.isShiftCacheStale, isTrue);
    });

    test('should detect stale shift cache when older than 24 hours', () {
      final oldSync = DateTime.now().subtract(const Duration(hours: 25));
      final stats = CacheStats(
        shiftCount: 10,
        attendanceCount: 5,
        locationLogCount: 100,
        checkCallCount: 20,
        syncQueueCount: 3,
        lastShiftSync: oldSync,
      );

      expect(stats.isShiftCacheStale, isTrue);
    });

    test('should detect valid shift cache when less than 24 hours', () {
      final recentSync = DateTime.now().subtract(const Duration(hours: 12));
      final stats = CacheStats(
        shiftCount: 10,
        attendanceCount: 5,
        locationLogCount: 100,
        checkCallCount: 20,
        syncQueueCount: 3,
        lastShiftSync: recentSync,
      );

      expect(stats.isShiftCacheStale, isFalse);
    });

    test('should detect stale check call cache when older than 1 hour', () {
      final oldSync = DateTime.now().subtract(const Duration(hours: 2));
      final stats = CacheStats(
        shiftCount: 10,
        attendanceCount: 5,
        locationLogCount: 100,
        checkCallCount: 20,
        syncQueueCount: 3,
        lastCheckCallSync: oldSync,
      );

      expect(stats.isCheckCallCacheStale, isTrue);
    });

    test('should detect valid check call cache when less than 1 hour', () {
      final recentSync = DateTime.now().subtract(const Duration(minutes: 30));
      final stats = CacheStats(
        shiftCount: 10,
        attendanceCount: 5,
        locationLogCount: 100,
        checkCallCount: 20,
        syncQueueCount: 3,
        lastCheckCallSync: recentSync,
      );

      expect(stats.isCheckCallCacheStale, isFalse);
    });
  });

  group('CacheCleanupResult', () {
    test('should calculate total deleted correctly', () {
      final result = CacheCleanupResult(
        locationLogsDeleted: 50,
        syncItemsDeleted: 10,
        shiftsDeleted: 5,
        attendancesDeleted: 3,
      );

      expect(result.totalDeleted, equals(68));
    });

    test('should handle zero deletions', () {
      final result = CacheCleanupResult(
        locationLogsDeleted: 0,
        syncItemsDeleted: 0,
        shiftsDeleted: 0,
        attendancesDeleted: 0,
      );

      expect(result.totalDeleted, equals(0));
    });
  });

  group('CacheManager Constants', () {
    test('should have correct cache validity durations', () {
      expect(CacheManager.shiftCacheValidity, equals(const Duration(hours: 24)));
      expect(CacheManager.checkCallCacheValidity, equals(const Duration(hours: 1)));
      expect(CacheManager.locationLogRetention, equals(const Duration(days: 30)));
    });

    test('should have correct cache version', () {
      expect(CacheManager.currentCacheVersion, equals(1));
    });
  });
}

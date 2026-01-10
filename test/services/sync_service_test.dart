import 'package:flutter_test/flutter_test.dart';
import 'package:security_officer_app/services/sync_service.dart';

void main() {
  group('SyncResult', () {
    test('should correctly store processed, failed, and skipped counts', () {
      final result = SyncResult(
        processed: 10,
        failed: 2,
        skipped: 3,
      );

      expect(result.processed, equals(10));
      expect(result.failed, equals(2));
      expect(result.skipped, equals(3));
    });

    test('should handle zero values', () {
      final result = SyncResult(
        processed: 0,
        failed: 0,
        skipped: 0,
      );

      expect(result.processed, equals(0));
      expect(result.failed, equals(0));
      expect(result.skipped, equals(0));
    });
  });

  group('SyncStatus', () {
    test('should detect pending sync when operations exist', () {
      final status = SyncStatus(
        criticalPending: 1,
        highPriorityPending: 2,
        normalPending: 2,
        unsyncedLocationLogs: 10,
        failedOperations: 0,
        isOnline: true,
      );

      expect(status.hasPendingSync, isTrue);
      expect(status.pendingOperations, equals(5));
      expect(status.totalPending, equals(15));
    });

    test('should detect no pending sync when empty', () {
      final status = SyncStatus(
        criticalPending: 0,
        highPriorityPending: 0,
        normalPending: 0,
        unsyncedLocationLogs: 0,
        failedOperations: 0,
        isOnline: true,
      );

      expect(status.hasPendingSync, isFalse);
      expect(status.totalPending, equals(0));
    });

    test('should detect pending sync with only location logs', () {
      final status = SyncStatus(
        criticalPending: 0,
        highPriorityPending: 0,
        normalPending: 0,
        unsyncedLocationLogs: 50,
        failedOperations: 0,
        isOnline: true,
      );

      expect(status.hasPendingSync, isTrue);
      expect(status.totalPending, equals(50));
    });

    test('should correctly track online status', () {
      final onlineStatus = SyncStatus(
        criticalPending: 0,
        highPriorityPending: 0,
        normalPending: 0,
        unsyncedLocationLogs: 0,
        failedOperations: 0,
        isOnline: true,
      );

      final offlineStatus = SyncStatus(
        criticalPending: 0,
        highPriorityPending: 0,
        normalPending: 0,
        unsyncedLocationLogs: 0,
        failedOperations: 0,
        isOnline: false,
      );

      expect(onlineStatus.isOnline, isTrue);
      expect(offlineStatus.isOnline, isFalse);
    });

    test('should track failed operations separately', () {
      final status = SyncStatus(
        criticalPending: 1,
        highPriorityPending: 2,
        normalPending: 2,
        unsyncedLocationLogs: 10,
        failedOperations: 3,
        isOnline: true,
      );

      expect(status.failedOperations, equals(3));
      // Failed operations are not included in totalPending
      expect(status.totalPending, equals(15));
    });

    test('should detect critical pending items', () {
      final status = SyncStatus(
        criticalPending: 2,
        highPriorityPending: 0,
        normalPending: 0,
        unsyncedLocationLogs: 0,
        failedOperations: 0,
        isOnline: true,
      );

      expect(status.hasCritical, isTrue);
      expect(status.criticalPending, equals(2));
    });
  });
}

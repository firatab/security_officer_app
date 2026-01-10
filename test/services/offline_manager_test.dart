import 'package:flutter_test/flutter_test.dart';
import 'package:security_officer_app/services/offline_manager.dart';

void main() {
  group('OfflineState', () {
    test('should initialize with default values', () {
      final state = OfflineState();

      expect(state.status, equals(ConnectivityStatus.offline));
      expect(state.isSyncing, isFalse);
      expect(state.pendingOperations, equals(0));
      expect(state.failedOperations, equals(0));
      expect(state.lastSyncTime, isNull);
      expect(state.lastError, isNull);
    });

    test('should detect online status correctly', () {
      final onlineState = OfflineState(status: ConnectivityStatus.online);
      final offlineState = OfflineState(status: ConnectivityStatus.offline);
      final syncingState = OfflineState(status: ConnectivityStatus.syncing);

      expect(onlineState.isOnline, isTrue);
      expect(offlineState.isOnline, isFalse);
      expect(syncingState.isOnline, isFalse);
    });

    test('should detect unsynced data correctly', () {
      final withPending = OfflineState(pendingOperations: 5);
      final withFailed = OfflineState(failedOperations: 3);
      final withBoth = OfflineState(pendingOperations: 5, failedOperations: 3);
      final withNone = OfflineState();

      expect(withPending.hasUnsynced, isTrue);
      expect(withFailed.hasUnsynced, isTrue);
      expect(withBoth.hasUnsynced, isTrue);
      expect(withNone.hasUnsynced, isFalse);
    });

    test('copyWith should create new instance with updated values', () {
      final original = OfflineState(
        status: ConnectivityStatus.offline,
        isSyncing: false,
        pendingOperations: 0,
      );

      final updated = original.copyWith(
        status: ConnectivityStatus.online,
        pendingOperations: 10,
      );

      expect(updated.status, equals(ConnectivityStatus.online));
      expect(updated.pendingOperations, equals(10));
      expect(updated.isSyncing, isFalse); // Should keep original value
    });

    test('copyWith should preserve null for lastSyncTime when not updated', () {
      final original = OfflineState();
      final updated = original.copyWith(status: ConnectivityStatus.online);

      expect(updated.lastSyncTime, isNull);
    });

    test('copyWith should update lastSyncTime when provided', () {
      final original = OfflineState();
      final now = DateTime.now();
      final updated = original.copyWith(lastSyncTime: now);

      expect(updated.lastSyncTime, equals(now));
    });

    test('copyWith should clear lastError when null passed', () {
      final original = OfflineState(lastError: 'Some error');
      final updated = original.copyWith(lastError: null);

      expect(updated.lastError, isNull);
    });
  });

  group('ConnectivityStatus', () {
    test('should have all expected values', () {
      expect(ConnectivityStatus.values.length, equals(3));
      expect(ConnectivityStatus.values, contains(ConnectivityStatus.online));
      expect(ConnectivityStatus.values, contains(ConnectivityStatus.offline));
      expect(ConnectivityStatus.values, contains(ConnectivityStatus.syncing));
    });
  });

  group('OfflineManager Constants', () {
    test('should have correct sync interval', () {
      expect(OfflineManager.syncInterval, equals(const Duration(minutes: 5)));
    });

    test('should have correct queue check interval', () {
      expect(
        OfflineManager.queueCheckInterval,
        equals(const Duration(seconds: 30)),
      );
    });
  });

  group('OfflineState Scenarios', () {
    test('should represent online with no pending sync', () {
      final state = OfflineState(
        status: ConnectivityStatus.online,
        isSyncing: false,
        pendingOperations: 0,
      );

      expect(state.isOnline, isTrue);
      expect(state.hasUnsynced, isFalse);
      expect(state.isSyncing, isFalse);
    });

    test('should represent offline with pending sync', () {
      final state = OfflineState(
        status: ConnectivityStatus.offline,
        isSyncing: false,
        pendingOperations: 15,
      );

      expect(state.isOnline, isFalse);
      expect(state.hasUnsynced, isTrue);
      expect(state.pendingOperations, equals(15));
    });

    test('should represent active sync in progress', () {
      final state = OfflineState(
        status: ConnectivityStatus.syncing,
        isSyncing: true,
        pendingOperations: 10,
      );

      expect(state.isOnline, isFalse);
      expect(state.isSyncing, isTrue);
      expect(state.hasUnsynced, isTrue);
    });

    test('should represent sync completed with error', () {
      final state = OfflineState(
        status: ConnectivityStatus.online,
        isSyncing: false,
        pendingOperations: 5,
        lastError: 'Network timeout',
        lastSyncTime: DateTime.now(),
      );

      expect(state.isOnline, isTrue);
      expect(state.isSyncing, isFalse);
      expect(state.lastError, equals('Network timeout'));
      expect(state.lastSyncTime, isNotNull);
    });
  });
}

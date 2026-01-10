part of '../app_database.dart';

@DriftAccessor(tables: [CheckCalls])
class CheckCallsDao extends DatabaseAccessor<AppDatabase> {
  CheckCallsDao(super.db);

  $CheckCallsTable get _checkCalls => attachedDatabase.checkCalls;

  Future<List<CheckCall>> getCheckCallsForShift(String shiftId) {
    return (select(_checkCalls)..where((tbl) => tbl.shiftId.equals(shiftId))).get();
  }

  Future<List<CheckCall>> getPendingCheckCalls(String employeeId) {
    return (select(_checkCalls)
          ..where((tbl) =>
              tbl.employeeId.equals(employeeId) &
              tbl.status.equals('pending')))
        .get();
  }

  Future<List<CheckCall>> getUnsyncedCheckCalls() {
    return (select(_checkCalls)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<void> markCheckCallMissed(String checkCallId) {
    return (update(_checkCalls)..where((tbl) => tbl.id.equals(checkCallId)))
        .write(const CheckCallsCompanion(status: Value('missed')));
  }

  Future<void> updateCheckCallStatus(String checkCallId, String status) {
    return (update(_checkCalls)..where((tbl) => tbl.id.equals(checkCallId)))
        .write(CheckCallsCompanion(
          status: Value(status),
          respondedAt: Value(DateTime.now()),
        ));
  }

  Future<void> respondToCheckCallOffline({
    required String checkCallId,
    required double latitude,
    required double longitude,
    String? notes,
  }) {
    return (update(_checkCalls)..where((tbl) => tbl.id.equals(checkCallId))).write(
      CheckCallsCompanion(
        respondedAt: Value(DateTime.now()),
        latitude: Value(latitude),
        longitude: Value(longitude),
        status: const Value('answered'),
        notes: Value(notes),
        needsSync: const Value(true),
      ),
    );
  }

  Future<int> markAsSynced(String id) {
    return (update(_checkCalls)..where((tbl) => tbl.id.equals(id)))
        .write(CheckCallsCompanion(
          needsSync: const Value(false),
          syncedAt: Value(DateTime.now()),
        ));
  }

  Future<int> insertCheckCall(CheckCallsCompanion checkCall) {
    return into(_checkCalls).insert(checkCall);
  }
}

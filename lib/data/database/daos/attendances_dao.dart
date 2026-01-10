part of '../app_database.dart';

@DriftAccessor(tables: [Attendances])
class AttendancesDao extends DatabaseAccessor<AppDatabase> {
  AttendancesDao(super.db);

  $AttendancesTable get _attendances => attachedDatabase.attendances;

  Future<Attendance?> getAttendanceForShift(String shiftId) {
    return (select(_attendances)..where((tbl) => tbl.shiftId.equals(shiftId)))
        .getSingleOrNull();
  }

  Future<List<Attendance>> getUnsyncedAttendances() {
    return (select(_attendances)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<int> insertAttendance(AttendancesCompanion attendance) {
    return into(_attendances).insert(attendance);
  }

  Future<bool> updateAttendance(Attendance attendance) {
    return update(_attendances).replace(attendance);
  }

  Future<int> markAsSynced(String id) {
    return (update(_attendances)..where((tbl) => tbl.id.equals(id)))
        .write(AttendancesCompanion(
          needsSync: const Value(false),
          syncedAt: Value(DateTime.now()),
        ));
  }
}

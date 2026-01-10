part of '../app_database.dart';

@DriftAccessor(tables: [Shifts])
class ShiftsDao extends DatabaseAccessor<AppDatabase> {
  ShiftsDao(super.db);

  $ShiftsTable get _shifts => attachedDatabase.shifts;

  Future<List<Shift>> getShiftsInRange(DateTime start, DateTime end) {
    return (select(_shifts)
          ..where((tbl) => tbl.shiftDate.isBetweenValues(start, end))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.shiftDate)]))
        .get();
  }

  Future<List<Shift>> getAllShifts() {
    return (select(_shifts)..orderBy([(tbl) => OrderingTerm.desc(tbl.shiftDate)])).get();
  }

  Future<Shift?> getShiftById(String id) {
    return (select(_shifts)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertShift(ShiftsCompanion shift) {
    return into(_shifts).insert(shift);
  }

  Future<bool> updateShift(Shift shift) {
    return update(_shifts).replace(shift);
  }

  Future<int> deleteShift(String id) {
    return (delete(_shifts)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> upsertShifts(List<ShiftsCompanion> shiftsData) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(_shifts, shiftsData);
    });
  }
}

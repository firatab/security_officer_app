part of '../app_database.dart';

@DriftAccessor(tables: [LocationLogs])
class LocationLogsDao extends DatabaseAccessor<AppDatabase> {
  LocationLogsDao(super.db);

  $LocationLogsTable get _locationLogs => attachedDatabase.locationLogs;

  Future<List<LocationLog>> getUnsyncedLocationLogs({int limit = 100}) {
    return (select(_locationLogs)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)])
          ..limit(limit))
        .get();
  }

  Future<int> insertLocationLog(LocationLogsCompanion log) {
    return into(_locationLogs).insert(log);
  }

  Future<int> markAsSynced(String id) {
    return (update(_locationLogs)..where((tbl) => tbl.id.equals(id)))
        .write(LocationLogsCompanion(
          needsSync: const Value(false),
          syncedAt: Value(DateTime.now()),
        ));
  }

  Future<int> markBatchAsSynced(List<String> ids) async {
    int count = 0;
    for (final id in ids) {
      count += await markAsSynced(id);
    }
    return count;
  }
}

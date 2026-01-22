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

  /// DIAGNOSTIC METHODS - for debugging sync issues
  
  Future<int> countTotal() async {
    final query = selectOnly(_locationLogs)..addColumns([_locationLogs.id.count()]);
    final result = await query.getSingle();
    return result.read(_locationLogs.id.count()) ?? 0;
  }

  Future<int> countUnsynced() async {
    final query = selectOnly(_locationLogs)
      ..where(_locationLogs.needsSync.equals(true))
      ..addColumns([_locationLogs.id.count()]);
    final result = await query.getSingle();
    return result.read(_locationLogs.id.count()) ?? 0;
  }

  Future<List<LocationLog>> getRecentLogs({int limit = 10}) {
    return (select(_locationLogs)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])
          ..limit(limit))
        .get();
  }
}

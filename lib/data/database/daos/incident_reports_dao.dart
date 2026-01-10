part of '../app_database.dart';

@DriftAccessor(tables: [IncidentReports])
class IncidentReportsDao extends DatabaseAccessor<AppDatabase> {
  IncidentReportsDao(super.db);

  $IncidentReportsTable get _incidentReports => attachedDatabase.incidentReports;

  Future<List<IncidentReport>> getUnsyncedIncidentReports({int limit = 50}) {
    return (select(_incidentReports)
          ..where((tbl) => tbl.needsSync.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<int> insertIncidentReport(IncidentReportsCompanion report) {
    return into(_incidentReports).insert(report);
  }

  Future<int> markAsSynced(String id) {
    return (update(_incidentReports)..where((tbl) => tbl.id.equals(id)))
        .write(IncidentReportsCompanion(
          needsSync: const Value(false),
          syncedAt: Value(DateTime.now()),
        ));
  }

  Future<int> updateServerId(String localId, String serverId) {
    return (update(_incidentReports)..where((tbl) => tbl.id.equals(localId)))
        .write(IncidentReportsCompanion(serverId: Value(serverId)));
  }
}

part of '../app_database.dart';

@DriftAccessor(tables: [Patrols, Checkpoints])
class PatrolsDao extends DatabaseAccessor<AppDatabase> {
  PatrolsDao(super.db);

  $PatrolsTable get _patrols => attachedDatabase.patrols;
  $CheckpointsTable get _checkpoints => attachedDatabase.checkpoints;

  Future<List<PatrolWithCheckpoints>> getPatrolsForSite(String siteId) async {
    final query = select(_patrols)..where((p) => p.siteId.equals(siteId));
    final patrolsResult = await query.get();

    final patrolsWithCheckpoints = <PatrolWithCheckpoints>[];
    for (final patrol in patrolsResult) {
      final checkpointsResult = await (select(_checkpoints)..where((c) => c.patrolId.equals(patrol.id))).get();
      patrolsWithCheckpoints.add(PatrolWithCheckpoints(patrol, checkpointsResult));
    }

    return patrolsWithCheckpoints;
  }

  Future<int> insertPatrol(PatrolsCompanion patrol) {
    return into(_patrols).insert(patrol);
  }

  Future<int> insertCheckpoint(CheckpointsCompanion checkpoint) {
    return into(_checkpoints).insert(checkpoint);
  }

  Future<int> markCheckpointCompleted(String checkpointId) {
    return (update(_checkpoints)..where((tbl) => tbl.id.equals(checkpointId)))
        .write(CheckpointsCompanion(
          completed: const Value(true),
          completedAt: Value(DateTime.now()),
          needsSync: const Value(true),
        ));
  }

  /// Get unsynced patrol checkpoint visits
  Future<List<Checkpoint>> getUnsyncedPatrolVisits() {
    return (select(_checkpoints)
          ..where((tbl) => tbl.needsSync.equals(true) & tbl.completed.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.completedAt)]))
        .get();
  }

  /// Mark a patrol checkpoint visit as synced
  Future<int> markPatrolVisitSynced(String checkpointId) {
    return (update(_checkpoints)..where((tbl) => tbl.id.equals(checkpointId)))
        .write(CheckpointsCompanion(
          needsSync: const Value(false),
          syncedAt: Value(DateTime.now()),
        ));
  }
}

class PatrolWithCheckpoints {
  final Patrol patrol;
  final List<Checkpoint> checkpoints;

  PatrolWithCheckpoints(this.patrol, this.checkpoints);
}

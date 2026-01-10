import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// Import the consolidated table definitions
import 'tables.dart';
import 'tables/patrol_tours.dart';

// DAO part files
part 'daos/shifts_dao.dart';
part 'daos/attendances_dao.dart';
part 'daos/location_logs_dao.dart';
part 'daos/check_calls_dao.dart';
part 'daos/sync_queue_dao.dart';
part 'daos/incident_reports_dao.dart';
part 'daos/patrols_dao.dart';
part 'daos/patrol_tours_dao.dart';
part 'daos/patrol_instances_dao.dart';
part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Shifts,
    Attendances,
    LocationLogs,
    CheckCalls,
    SyncQueue,
    IncidentReports,
    Patrols,
    Checkpoints,
    // New patrol tour tables
    PatrolTours,
    PatrolTourPoints,
    PatrolTasks,
    PatrolInstances,
    PatrolPointCompletions,
    PatrolTaskResponses,
  ],
  daos: [
    ShiftsDao,
    AttendancesDao,
    LocationLogsDao,
    CheckCallsDao,
    SyncQueueDao,
    IncidentReportsDao,
    PatrolsDao,
    PatrolToursDao,
    PatrolInstancesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Override DAO instances (generated in _$AppDatabase)
  @override
  late final ShiftsDao shiftsDao = ShiftsDao(this);
  @override
  late final AttendancesDao attendancesDao = AttendancesDao(this);
  @override
  late final LocationLogsDao locationLogsDao = LocationLogsDao(this);
  @override
  late final CheckCallsDao checkCallsDao = CheckCallsDao(this);
  @override
  late final SyncQueueDao syncQueueDao = SyncQueueDao(this);
  @override
  late final IncidentReportsDao incidentReportsDao = IncidentReportsDao(this);
  @override
  late final PatrolsDao patrolsDao = PatrolsDao(this);
  @override
  late final PatrolToursDao patrolToursDao = PatrolToursDao(this);
  @override
  late final PatrolInstancesDao patrolInstancesDao = PatrolInstancesDao(this);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) => m.createAll(),
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(incidentReports);
        }
        if (from < 3) {
          await m.createTable(patrols);
          await m.createTable(checkpoints);
        }
        if (from < 4) {
          // Add new columns to sync_queue
          await m.addColumn(syncQueue, syncQueue.priority);
          await m.addColumn(syncQueue, syncQueue.entityType);
          await m.addColumn(syncQueue, syncQueue.entityId);
          // Add new columns to incident_reports
          await m.addColumn(incidentReports, incidentReports.serverId);
          await m.addColumn(incidentReports, incidentReports.siteId);
          await m.addColumn(incidentReports, incidentReports.title);
          await m.addColumn(incidentReports, incidentReports.incidentDate);
          await m.addColumn(incidentReports, incidentReports.location);
          await m.addColumn(incidentReports, incidentReports.actionTaken);
          await m.addColumn(incidentReports, incidentReports.policeNotified);
          await m.addColumn(incidentReports, incidentReports.policeRef);
          await m.addColumn(incidentReports, incidentReports.syncedAt);
          // Add new columns to checkpoints
          await m.addColumn(checkpoints, checkpoints.needsSync);
          await m.addColumn(checkpoints, checkpoints.syncedAt);
        }
        if (from < 5) {
          // Create new patrol tour tables
          await m.createTable(patrolTours);
          await m.createTable(patrolTourPoints);
          await m.createTable(patrolTasks);
          await m.createTable(patrolInstances);
          await m.createTable(patrolPointCompletions);
          await m.createTable(patrolTaskResponses);
        }
      },
    );
  }

  // Convenience methods that delegate to DAOs
  Future<List<Shift>> getShiftsInRange(DateTime start, DateTime end) =>
      shiftsDao.getShiftsInRange(start, end);

  Future<Attendance?> getAttendanceForShift(String shiftId) =>
      attendancesDao.getAttendanceForShift(shiftId);

  Future<List<LocationLog>> getUnsyncedLocationLogs({int limit = 100}) =>
      locationLogsDao.getUnsyncedLocationLogs(limit: limit);

  Future<List<SyncQueueData>> getPendingSyncItems() =>
      syncQueueDao.getPendingSyncItems();

  Future<List<IncidentReport>> getUnsyncedIncidentReports({int limit = 50}) =>
      incidentReportsDao.getUnsyncedIncidentReports(limit: limit);

  Future<List<CheckCall>> getCheckCallsForShift(String shiftId) =>
      checkCallsDao.getCheckCallsForShift(shiftId);

  Future<List<CheckCall>> getPendingCheckCalls(String employeeId) =>
      checkCallsDao.getPendingCheckCalls(employeeId);

  // Check call sync methods
  Future<List<CheckCall>> getUnsyncedCheckCalls() =>
      checkCallsDao.getUnsyncedCheckCalls();

  Future<int> markCheckCallSynced(String id) =>
      checkCallsDao.markAsSynced(id);

  // Incident report sync methods
  Future<int> updateIncidentServerId(String localId, String serverId) =>
      incidentReportsDao.updateServerId(localId, serverId);

  Future<int> markIncidentSynced(String id) =>
      incidentReportsDao.markAsSynced(id);

  // Patrol sync methods
  Future<List<Checkpoint>> getUnsyncedPatrolVisits() =>
      patrolsDao.getUnsyncedPatrolVisits();

  Future<int> markPatrolVisitSynced(String checkpointId) =>
      patrolsDao.markPatrolVisitSynced(checkpointId);

  // Patrol tour convenience methods
  Future<List<PatrolTour>> getPatrolToursForSite(String siteId) =>
      patrolToursDao.getToursForSite(siteId);

  Future<PatrolInstance?> getActivePatrolInstance(String employeeId) =>
      patrolInstancesDao.getActiveInstance(employeeId);

  Future<List<PatrolInstance>> getUnsyncedPatrolInstances() =>
      patrolInstancesDao.getUnsyncedInstances();

  Future<List<PatrolPointCompletion>> getUnsyncedPointCompletions() =>
      patrolInstancesDao.getUnsyncedCompletions();

  Future<void> clearAllData() async {
    await transaction(() async {
      await Future.wait([
        delete(shifts).go(),
        delete(attendances).go(),
        delete(locationLogs).go(),
        delete(checkCalls).go(),
        delete(syncQueue).go(),
        delete(incidentReports).go(),
        delete(patrols).go(),
        delete(checkpoints).go(),
        // New patrol tour tables
        delete(patrolTours).go(),
        delete(patrolTourPoints).go(),
        delete(patrolTasks).go(),
        delete(patrolInstances).go(),
        delete(patrolPointCompletions).go(),
        delete(patrolTaskResponses).go(),
      ]);
    });
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'security_officer_db');
}

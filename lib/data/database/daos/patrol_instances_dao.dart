part of '../app_database.dart';

@DriftAccessor(
    tables: [PatrolInstances, PatrolPointCompletions, PatrolTaskResponses])
class PatrolInstancesDao extends DatabaseAccessor<AppDatabase>
    with _$PatrolInstancesDaoMixin {
  PatrolInstancesDao(super.db);

  /// Get active patrol instance for an employee (in_progress status)
  Future<PatrolInstance?> getActiveInstance(String employeeId) {
    return (select(patrolInstances)
          ..where((i) =>
              i.employeeId.equals(employeeId) &
              i.status.equals('in_progress')))
        .getSingleOrNull();
  }

  /// Get a single patrol instance by ID
  Future<PatrolInstance?> getInstanceById(String id) {
    return (select(patrolInstances)..where((i) => i.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get all instances for a shift
  Future<List<PatrolInstance>> getInstancesForShift(String shiftId) {
    return (select(patrolInstances)
          ..where((i) => i.shiftId.equals(shiftId))
          ..orderBy([(i) => OrderingTerm.desc(i.createdAt)]))
        .get();
  }

  /// Get all unsynced patrol instances
  Future<List<PatrolInstance>> getUnsyncedInstances() {
    return (select(patrolInstances)..where((i) => i.needsSync.equals(true)))
        .get();
  }

  /// Get all unsynced point completions
  Future<List<PatrolPointCompletion>> getUnsyncedCompletions() {
    return (select(patrolPointCompletions)
          ..where((c) => c.needsSync.equals(true)))
        .get();
  }

  /// Get all unsynced task responses
  Future<List<PatrolTaskResponse>> getUnsyncedTaskResponses() {
    return (select(patrolTaskResponses)
          ..where((r) => r.needsSync.equals(true)))
        .get();
  }

  /// Get point completions for an instance
  Future<List<PatrolPointCompletion>> getCompletionsForInstance(
      String instanceId) {
    return (select(patrolPointCompletions)
          ..where((c) => c.patrolInstanceId.equals(instanceId)))
        .get();
  }

  /// Get task responses for a point completion
  Future<List<PatrolTaskResponse>> getTaskResponsesForCompletion(
      String completionId) {
    return (select(patrolTaskResponses)
          ..where((r) => r.pointCompletionId.equals(completionId)))
        .get();
  }

  /// Create a new patrol instance
  Future<int> createInstance(PatrolInstancesCompanion instance) {
    return into(patrolInstances).insert(instance);
  }

  /// Update patrol instance
  Future<int> updateInstance(PatrolInstancesCompanion instance) {
    return (update(patrolInstances)
          ..where((i) => i.id.equals(instance.id.value)))
        .write(instance);
  }

  /// Start a patrol instance
  Future<int> startInstance(String instanceId) {
    return (update(patrolInstances)..where((i) => i.id.equals(instanceId)))
        .write(PatrolInstancesCompanion(
      status: const Value('in_progress'),
      actualStart: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      needsSync: const Value(true),
    ));
  }

  /// Complete a patrol instance
  Future<int> completeInstance(String instanceId, {String? notes}) {
    return (update(patrolInstances)..where((i) => i.id.equals(instanceId)))
        .write(PatrolInstancesCompanion(
      status: const Value('completed'),
      actualEnd: Value(DateTime.now()),
      notes: notes != null ? Value(notes) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
      needsSync: const Value(true),
    ));
  }

  /// Abandon a patrol instance
  Future<int> abandonInstance(String instanceId, {String? reason}) {
    return (update(patrolInstances)..where((i) => i.id.equals(instanceId)))
        .write(PatrolInstancesCompanion(
      status: const Value('abandoned'),
      actualEnd: Value(DateTime.now()),
      notes: reason != null ? Value(reason) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
      needsSync: const Value(true),
    ));
  }

  /// Increment completed points count
  Future<void> incrementCompletedPoints(String instanceId) async {
    final instance = await getInstanceById(instanceId);
    if (instance != null) {
      await (update(patrolInstances)..where((i) => i.id.equals(instanceId)))
          .write(PatrolInstancesCompanion(
        completedPoints: Value(instance.completedPoints + 1),
        updatedAt: Value(DateTime.now()),
        needsSync: const Value(true),
      ));
    }
  }

  /// Save a point completion
  Future<int> savePointCompletion(PatrolPointCompletionsCompanion completion) {
    return into(patrolPointCompletions).insertOnConflictUpdate(completion);
  }

  /// Update point completion status
  Future<int> updatePointCompletionStatus(String completionId, String status) {
    return (update(patrolPointCompletions)
          ..where((c) => c.id.equals(completionId)))
        .write(PatrolPointCompletionsCompanion(
      status: Value(status),
      completedAt:
          status == 'completed' ? Value(DateTime.now()) : const Value.absent(),
      needsSync: const Value(true),
    ));
  }

  /// Save a task response
  Future<int> saveTaskResponse(PatrolTaskResponsesCompanion response) {
    return into(patrolTaskResponses).insertOnConflictUpdate(response);
  }

  /// Mark patrol instance as synced
  Future<int> markInstanceSynced(String instanceId, {String? serverId}) {
    return (update(patrolInstances)..where((i) => i.id.equals(instanceId)))
        .write(PatrolInstancesCompanion(
      serverId: serverId != null ? Value(serverId) : const Value.absent(),
      needsSync: const Value(false),
      syncedAt: Value(DateTime.now()),
    ));
  }

  /// Mark point completion as synced
  Future<int> markCompletionSynced(String completionId, {String? serverId}) {
    return (update(patrolPointCompletions)
          ..where((c) => c.id.equals(completionId)))
        .write(PatrolPointCompletionsCompanion(
      serverId: serverId != null ? Value(serverId) : const Value.absent(),
      needsSync: const Value(false),
      syncedAt: Value(DateTime.now()),
    ));
  }

  /// Mark task response as synced
  Future<int> markTaskResponseSynced(String responseId, {String? serverId}) {
    return (update(patrolTaskResponses)..where((r) => r.id.equals(responseId)))
        .write(PatrolTaskResponsesCompanion(
      serverId: serverId != null ? Value(serverId) : const Value.absent(),
      needsSync: const Value(false),
      syncedAt: Value(DateTime.now()),
    ));
  }

  /// Get instance with all completions and task responses
  Future<Map<String, dynamic>?> getInstanceWithCompletions(
      String instanceId) async {
    final instance = await getInstanceById(instanceId);
    if (instance == null) return null;

    final completions = await getCompletionsForInstance(instanceId);

    final completionsWithResponses = <Map<String, dynamic>>[];
    for (final completion in completions) {
      final responses = await getTaskResponsesForCompletion(completion.id);
      completionsWithResponses.add({
        'completion': completion,
        'taskResponses': responses,
      });
    }

    return {
      'instance': instance,
      'completions': completionsWithResponses,
    };
  }

  /// Clear all patrol instance data (for refresh or logout)
  Future<void> clearAllPatrolInstanceData() async {
    await transaction(() async {
      await delete(patrolTaskResponses).go();
      await delete(patrolPointCompletions).go();
      await delete(patrolInstances).go();
    });
  }

  /// Get pending instances for today
  Future<List<PatrolInstance>> getPendingInstancesForToday(
      String employeeId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(patrolInstances)
          ..where((i) =>
              i.employeeId.equals(employeeId) &
              i.status.equals('pending') &
              i.scheduledStart.isBiggerOrEqualValue(startOfDay) &
              i.scheduledStart.isSmallerThanValue(endOfDay))
          ..orderBy([(i) => OrderingTerm.asc(i.scheduledStart)]))
        .get();
  }

  /// Get completed instances for today
  Future<List<PatrolInstance>> getCompletedInstancesForToday(
      String employeeId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(patrolInstances)
          ..where((i) =>
              i.employeeId.equals(employeeId) &
              i.status.equals('completed') &
              i.actualEnd.isBiggerOrEqualValue(startOfDay) &
              i.actualEnd.isSmallerThanValue(endOfDay))
          ..orderBy([(i) => OrderingTerm.desc(i.actualEnd)]))
        .get();
  }
}

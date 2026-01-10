part of '../app_database.dart';

@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase> {
  SyncQueueDao(super.db);

  $SyncQueueTable get _syncQueue => attachedDatabase.syncQueue;

  /// Get pending sync items, ordered by priority (highest first) then by creation time
  Future<List<SyncQueueData>> getPendingSyncItems() {
    return (select(_syncQueue)
          ..where((tbl) => tbl.status.equals('pending'))
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.priority), // Higher priority first
            (tbl) => OrderingTerm.asc(tbl.createdAt),  // Then by oldest first
          ]))
        .get();
  }

  /// Get pending sync items by priority level
  Future<List<SyncQueueData>> getPendingByPriority(int priority) {
    return (select(_syncQueue)
          ..where((tbl) => tbl.status.equals('pending') & tbl.priority.equals(priority))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  /// Get critical priority items (panic alerts, emergencies)
  Future<List<SyncQueueData>> getCriticalPendingItems() {
    return getPendingByPriority(SyncPriority.critical);
  }

  /// Get high priority items (check calls, attendance)
  Future<List<SyncQueueData>> getHighPriorityItems() {
    return getPendingByPriority(SyncPriority.high);
  }

  /// Get count of pending items by priority
  Future<int> getPendingCountByPriority(int priority) async {
    final query = selectOnly(_syncQueue)
      ..addColumns([_syncQueue.id.count()])
      ..where(_syncQueue.status.equals('pending') & _syncQueue.priority.equals(priority));
    final result = await query.getSingle();
    return result.read(_syncQueue.id.count()) ?? 0;
  }

  /// Get total pending count
  Future<int> getPendingCount() async {
    final query = selectOnly(_syncQueue)
      ..addColumns([_syncQueue.id.count()])
      ..where(_syncQueue.status.equals('pending'));
    final result = await query.getSingle();
    return result.read(_syncQueue.id.count()) ?? 0;
  }

  /// Insert sync item with priority
  Future<int> insertSyncItem(SyncQueueCompanion item) {
    return into(_syncQueue).insert(item);
  }

  /// Insert or update sync item (for upsert scenarios)
  Future<int> upsertSyncItem(SyncQueueCompanion item) {
    return into(_syncQueue).insertOnConflictUpdate(item);
  }

  /// Find existing sync item by entity type and ID (for conflict resolution)
  Future<SyncQueueData?> findByEntity(String entityType, String entityId) {
    return (select(_syncQueue)
          ..where((tbl) => tbl.entityType.equals(entityType) & tbl.entityId.equals(entityId))
          ..where((tbl) => tbl.status.isIn(['pending', 'processing']))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Update sync item status
  Future<int> updateSyncItemStatus(String id, String status, {String? errorMessage}) {
    return (update(_syncQueue)..where((tbl) => tbl.id.equals(id)))
        .write(SyncQueueCompanion(
          status: Value(status),
          errorMessage: Value(errorMessage),
          lastAttemptAt: Value(DateTime.now()),
        ));
  }

  /// Mark item as processing
  Future<int> markAsProcessing(String id) {
    return updateSyncItemStatus(id, 'processing');
  }

  /// Mark item as completed
  Future<int> markAsCompleted(String id) {
    return updateSyncItemStatus(id, 'completed');
  }

  /// Mark item as failed
  Future<int> markAsFailed(String id, String errorMessage) {
    return updateSyncItemStatus(id, 'failed', errorMessage: errorMessage);
  }

  /// Increment retry count
  Future<int> incrementRetryCount(String id) {
    return customUpdate(
      'UPDATE sync_queue SET retry_count = retry_count + 1, last_attempt_at = ? WHERE id = ?',
      variables: [Variable.withDateTime(DateTime.now()), Variable.withString(id)],
      updates: {_syncQueue},
    );
  }

  /// Reset failed items to pending (for retry)
  Future<int> resetFailedItems() {
    return (update(_syncQueue)
          ..where((tbl) => tbl.status.equals('failed'))
          ..where((tbl) => tbl.retryCount.isSmallerThan(tbl.maxRetries)))
        .write(const SyncQueueCompanion(
          status: Value('pending'),
        ));
  }

  /// Delete sync item
  Future<int> deleteSyncItem(String id) {
    return (delete(_syncQueue)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Delete completed items
  Future<int> deleteCompletedItems() {
    return (delete(_syncQueue)..where((tbl) => tbl.status.equals('completed'))).go();
  }

  /// Delete old completed items (older than specified duration)
  Future<int> deleteOldCompletedItems(Duration age) {
    final cutoff = DateTime.now().subtract(age);
    return (delete(_syncQueue)
          ..where((tbl) => tbl.status.equals('completed'))
          ..where((tbl) => tbl.createdAt.isSmallerThanValue(cutoff)))
        .go();
  }

  /// Delete all items for a specific entity (when entity is deleted)
  Future<int> deleteByEntity(String entityType, String entityId) {
    return (delete(_syncQueue)
          ..where((tbl) => tbl.entityType.equals(entityType) & tbl.entityId.equals(entityId)))
        .go();
  }

  /// Watch pending sync items count
  Stream<int> watchPendingCount() {
    final query = selectOnly(_syncQueue)
      ..addColumns([_syncQueue.id.count()])
      ..where(_syncQueue.status.equals('pending'));
    return query.watchSingle().map((row) => row.read(_syncQueue.id.count()) ?? 0);
  }

  /// Watch pending sync items
  Stream<List<SyncQueueData>> watchPendingItems() {
    return (select(_syncQueue)
          ..where((tbl) => tbl.status.equals('pending'))
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.priority),
            (tbl) => OrderingTerm.asc(tbl.createdAt),
          ]))
        .watch();
  }
}

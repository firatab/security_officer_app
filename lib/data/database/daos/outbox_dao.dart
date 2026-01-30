part of '../app_database.dart';

@DriftAccessor(tables: [OutboxEvents, SyncState])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(AppDatabase db) : super(db);

  // ================== Outbox Events ==================

  /// Add an event to the outbox for publishing
  Future<void> addEvent({
    required String eventId,
    required String tenantId,
    required String type,
    String? entityType,
    String? entityId,
    required Map<String, dynamic> payload,
  }) async {
    await into(outboxEvents).insert(
      OutboxEventsCompanion.insert(
        eventId: eventId,
        tenantId: tenantId,
        type: type,
        entityType: Value(entityType),
        entityId: Value(entityId),
        payloadJson: jsonEncode(payload),
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Get pending events (not yet published)
  Future<List<OutboxEvent>> getPendingEvents({int limit = 50}) async {
    return (select(outboxEvents)
          ..where((tbl) => tbl.status.equals('pending'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])
          ..limit(limit))
        .get();
  }

  /// Get events ready for retry (based on exponential backoff)
  Future<List<OutboxEvent>> getEventsReadyForRetry({int limit = 20}) async {
    final now = DateTime.now();
    return (select(outboxEvents)
          ..where(
            (tbl) =>
                tbl.status.equals('failed') &
                (tbl.nextRetryAt.isSmallerOrEqualValue(now) |
                    tbl.nextRetryAt.isNull()),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])
          ..limit(limit))
        .get();
  }

  /// Mark event as published
  Future<void> markAsPublished(String eventId) async {
    await (update(
      outboxEvents,
    )..where((tbl) => tbl.eventId.equals(eventId))).write(
      OutboxEventsCompanion(
        status: const Value('published'),
        publishedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark event as failed and calculate next retry time (exponential backoff)
  Future<void> markAsFailed(
    String eventId,
    String error, {
    int? retryCount,
  }) async {
    // Exponential backoff: 2^retryCount minutes
    final nextRetryCount = (retryCount ?? 0) + 1;
    final backoffMinutes = (1 << nextRetryCount).clamp(1, 60); // Max 60 minutes
    final nextRetry = DateTime.now().add(Duration(minutes: backoffMinutes));

    await (update(
      outboxEvents,
    )..where((tbl) => tbl.eventId.equals(eventId))).write(
      OutboxEventsCompanion(
        status: const Value('failed'),
        retryCount: Value(nextRetryCount),
        lastError: Value(error),
        nextRetryAt: Value(nextRetry),
      ),
    );
  }

  /// Delete old published events (cleanup)
  Future<int> deletePublishedOlderThan(Duration age) async {
    final cutoff = DateTime.now().subtract(age);
    return (delete(outboxEvents)..where(
          (tbl) =>
              tbl.status.equals('published') &
              tbl.publishedAt.isSmallerOrEqualValue(cutoff),
        ))
        .go();
  }

  /// Get count of pending events
  Future<int> getPendingCount() async {
    final count = countAll();
    final query = selectOnly(outboxEvents)
      ..addColumns([count])
      ..where(outboxEvents.status.equals('pending'));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get count of failed events
  Future<int> getFailedCount() async {
    final count = countAll();
    final query = selectOnly(outboxEvents)
      ..addColumns([count])
      ..where(outboxEvents.status.equals('failed'));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ================== Sync State ==================

  /// Get sync watermark for entity
  Future<SyncStateData?> getSyncState(String entity, String tenantId) async {
    return (select(syncState)..where(
          (tbl) => tbl.entity.equals(entity) & tbl.tenantId.equals(tenantId),
        ))
        .getSingleOrNull();
  }

  /// Update sync watermark for entity
  Future<void> updateSyncState({
    required String entity,
    required String tenantId,
    required String watermark,
    int recordsSynced = 0,
    String status = 'idle',
    String? error,
  }) async {
    await into(syncState).insertOnConflictUpdate(
      SyncStateCompanion.insert(
        entity: entity,
        tenantId: tenantId,
        watermark: watermark,
        lastSyncAt: DateTime.now(),
        recordsSynced: Value(recordsSynced),
        syncStatus: Value(status),
        lastError: Value(error),
      ),
    );
  }

  /// Mark sync as failed for entity
  Future<void> markSyncFailed(
    String entity,
    String tenantId,
    String error,
  ) async {
    final current = await getSyncState(entity, tenantId);
    if (current == null) return;

    await updateSyncState(
      entity: entity,
      tenantId: tenantId,
      watermark: current.watermark,
      status: 'error',
      error: error,
    );
  }

  /// Reset sync state for entity (force full resync)
  Future<void> resetSyncState(String entity, String tenantId) async {
    await (delete(syncState)..where(
          (tbl) => tbl.entity.equals(entity) & tbl.tenantId.equals(tenantId),
        ))
        .go();
  }

  /// Get all sync states for tenant
  Future<List<SyncStateData>> getAllSyncStates(String tenantId) async {
    return (select(
      syncState,
    )..where((tbl) => tbl.tenantId.equals(tenantId))).get();
  }

  /// Check if sync is currently in progress for any entity
  Future<bool> isSyncInProgress(String tenantId) async {
    final count = countAll();
    final query = selectOnly(syncState)
      ..addColumns([count])
      ..where(
        syncState.tenantId.equals(tenantId) &
            syncState.syncStatus.equals('syncing'),
      );
    final result = await query.getSingle();
    return (result.read(count) ?? 0) > 0;
  }
}

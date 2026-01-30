import 'package:drift/drift.dart';

/// Outbox Events table for reliable event publishing
/// Implements the outbox pattern for ensuring events are published even if WebSocket is temporarily unavailable
class OutboxEvents extends Table {
  TextColumn get eventId => text()();
  TextColumn get tenantId => text()();
  TextColumn get type =>
      text()(); // Event type (shift:created, attendance:book_on, etc.)
  TextColumn get entityType =>
      text().nullable()(); // Entity type (shift, attendance, etc.)
  TextColumn get entityId => text().nullable()(); // Entity ID
  TextColumn get payloadJson => text()(); // JSON payload
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status => text().withDefault(
    const Constant('pending'),
  )(); // pending, published, failed
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get nextRetryAt =>
      dateTime().nullable()(); // For exponential backoff

  @override
  Set<Column> get primaryKey => {eventId};
}

/// Sync State table for watermark-based incremental sync
/// Tracks the last sync watermark for each entity type to enable efficient incremental syncing
class SyncState extends Table {
  TextColumn get entity =>
      text()(); // Entity type (shifts, attendances, checkCalls, etc.)
  TextColumn get tenantId => text()();
  TextColumn get watermark =>
      text()(); // Last sync watermark (timestamp, version, or sequence number)
  DateTimeColumn get lastSyncAt => dateTime()();
  IntColumn get recordsSynced => integer().withDefault(const Constant(0))();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('idle'))(); // idle, syncing, error
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {entity, tenantId};
}

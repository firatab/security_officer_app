import 'package:drift/drift.dart';

/// Sync queue priority levels
/// Higher number = higher priority
class SyncPriority {
  static const int normal = 0;       // Regular operations
  static const int high = 1;         // Check calls, attendance
  static const int critical = 2;     // Panic alerts, emergency operations
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get operation => text()(); // 'book_on', 'book_off', 'location', 'check_call', 'incident', 'panic', 'patrol'
  TextColumn get endpoint => text()();
  TextColumn get method => text()(); // GET, POST, PUT, DELETE
  TextColumn get payload => text()(); // JSON string

  /// Priority level for sync order (higher = synced first)
  /// 0 = normal, 1 = high (check calls), 2 = critical (panic alerts)
  IntColumn get priority => integer().withDefault(const Constant(0))();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  IntColumn get maxRetries => integer().withDefault(const Constant(3))();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, processing, failed, completed
  TextColumn get errorMessage => text().nullable()();

  /// Entity type for conflict resolution (e.g., 'attendance', 'check_call', 'incident')
  TextColumn get entityType => text().nullable()();
  /// Entity ID for conflict resolution
  TextColumn get entityId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

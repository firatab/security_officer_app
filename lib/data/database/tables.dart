import 'package:drift/drift.dart';

// All table classes are defined in thisingle file for simplicity.
// Export patrol tables
export 'patrols.dart';
// Export patrol tour tables
export 'tables/patrol_tours.dart';
// Export tenant configuration tables
export 'tables/tenant_config.dart';
// Export outbox tables
export 'tables/outbox.dart';
// Export notification tables
export 'tables/in_app_notifications.dart';

class Shifts extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get employeeId => text()();
  TextColumn get siteId => text()();
  TextColumn get clientId => text()();
  TextColumn get siteName => text()();
  TextColumn get siteAddress => text()();
  RealColumn get siteLatitude => real().nullable()();
  RealColumn get siteLongitude => real().nullable()();
  TextColumn get clientName => text()();
  DateTimeColumn get shiftDate => dateTime()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get breakMinutes => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  BoolColumn get checkCallEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get checkCallFrequency => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Attendances extends Table {
  TextColumn get id => text()();
  TextColumn get shiftId => text()();
  TextColumn get employeeId => text()();
  TextColumn get tenantId => text()();
  DateTimeColumn get bookOnTime => dateTime().nullable()();
  RealColumn get bookOnLatitude => real().nullable()();
  RealColumn get bookOnLongitude => real().nullable()();
  TextColumn get bookOnMethod => text().nullable()();
  DateTimeColumn get bookOffTime => dateTime().nullable()();
  RealColumn get bookOffLatitude => real().nullable()();
  RealColumn get bookOffLongitude => real().nullable()();
  TextColumn get bookOffMethod => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  RealColumn get totalHours => real().nullable()();
  BoolColumn get isLate => boolean().withDefault(const Constant(false))();
  IntColumn get lateMinutes => integer().nullable()();
  BoolColumn get autoBookedOff =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class LocationLogs extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text()();
  TextColumn get shiftId => text().nullable()();
  TextColumn get tenantId => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracy => real().nullable()();
  RealColumn get altitude => real().nullable()();
  RealColumn get speed => real().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {id};
}

class CheckCalls extends Table {
  TextColumn get id => text()();
  TextColumn get shiftId => text()();
  TextColumn get employeeId => text()();
  TextColumn get tenantId => text()();
  DateTimeColumn get scheduledTime => dateTime()();
  DateTimeColumn get respondedAt => dateTime().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

/// Sync queue priority levels
/// Higher number = higher priority
class SyncPriority {
  static const int normal = 0; // Regular operations
  static const int high = 1; // Check calls, attendance
  static const int critical = 2; // Panic alerts, emergency operations
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get operation =>
      text()(); // 'book_on', 'book_off', 'location', 'check_call', 'incident', 'panic', 'patrol'
  TextColumn get endpoint => text()();
  TextColumn get method => text()(); // GET, POST, PUT, DELETE
  TextColumn get payload => text()(); // JSON string

  /// Priority level for sync order (higher = synced first)
  /// 0 = normal, 1 = high (check calls), 2 = critical (panic alerts)
  IntColumn get priority => integer().withDefault(const Constant(0))();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  IntColumn get maxRetries => integer().withDefault(const Constant(3))();
  TextColumn get status => text().withDefault(
    const Constant('pending'),
  )(); // pending, processing, failed, completed
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

class IncidentReports extends Table {
  TextColumn get id => text()();
  TextColumn get serverId =>
      text().nullable()(); // Server-assigned ID after sync
  TextColumn get shiftId => text()();
  TextColumn get siteId => text()();
  TextColumn get employeeId => text()();
  TextColumn get tenantId => text()();
  TextColumn get title => text()();
  DateTimeColumn get incidentDate => dateTime()();
  DateTimeColumn get reportTime => dateTime()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get location => text().nullable()(); // Text location description
  TextColumn get incidentType => text()();
  TextColumn get description => text()();
  TextColumn get severity => text()();
  TextColumn get actionTaken => text().nullable()();
  BoolColumn get policeNotified =>
      boolean().withDefault(const Constant(false))();
  TextColumn get policeRef => text().nullable()();
  TextColumn get mediaFilePaths =>
      text().nullable()(); // Local file paths JSON array
  TextColumn get mediaUrls => text().nullable()(); // Server URLs JSON array
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

// Patrol-related tables are now in dedicated files:
// - Patrols and Checkpoints: patrols.dart
// - Patrol tours: tables/patrol_tours.dart

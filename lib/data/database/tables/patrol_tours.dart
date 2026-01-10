import 'package:drift/drift.dart';

/// Patrol tours - the main patrol route templates
class PatrolTours extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get clientId => text()();
  TextColumn get siteId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  // frequencyType: per_shift, fixed_interval, specific_times
  TextColumn get frequencyType => text().withDefault(const Constant('per_shift'))();
  IntColumn get intervalMinutes => integer().nullable()();
  // JSON array of times like ["09:00", "14:00", "18:00"]
  TextColumn get scheduledTimes => text().nullable()();
  TextColumn get startTime => text().nullable()();
  TextColumn get endTime => text().nullable()();
  BoolColumn get sequenceRequired => boolean().withDefault(const Constant(false))();
  IntColumn get estimatedDuration => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Patrol points - individual checkpoints within a tour
class PatrolTourPoints extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get patrolTourId => text()();
  TextColumn get checkpointId => text()();
  IntColumn get sequenceNumber => integer().withDefault(const Constant(0))();
  BoolColumn get requireScan => boolean().withDefault(const Constant(true))();
  BoolColumn get requirePhoto => boolean().withDefault(const Constant(false))();
  BoolColumn get requireNotes => boolean().withDefault(const Constant(false))();
  TextColumn get instructions => text().nullable()();
  IntColumn get expectedDuration => integer().withDefault(const Constant(5))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  // Denormalized checkpoint info for offline access
  TextColumn get checkpointName => text()();
  TextColumn get checkpointCode => text()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  IntColumn get geofenceRadius => integer().withDefault(const Constant(50))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Patrol tasks - checklist items at each point
class PatrolTasks extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get patrolPointId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  // taskType: checkbox, text, number, select, photo
  TextColumn get taskType => text().withDefault(const Constant('checkbox'))();
  // JSON array for select type options
  TextColumn get options => text().nullable()();
  BoolColumn get isRequired => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Patrol instances - actual execution of a patrol tour
class PatrolInstances extends Table {
  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()(); // Server ID after sync
  TextColumn get tenantId => text()();
  TextColumn get patrolTourId => text()();
  TextColumn get scheduleId => text().nullable()();
  TextColumn get shiftId => text().nullable()();
  TextColumn get employeeId => text()();
  DateTimeColumn get scheduledStart => dateTime().nullable()();
  DateTimeColumn get actualStart => dateTime().nullable()();
  DateTimeColumn get actualEnd => dateTime().nullable()();
  // status: pending, in_progress, completed, incomplete, abandoned
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get totalPoints => integer().withDefault(const Constant(0))();
  IntColumn get completedPoints => integer().withDefault(const Constant(0))();
  RealColumn get startLatitude => real().nullable()();
  RealColumn get startLongitude => real().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Patrol point completions - records of completing each checkpoint
class PatrolPointCompletions extends Table {
  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get tenantId => text()();
  TextColumn get patrolInstanceId => text()();
  TextColumn get patrolPointId => text()();
  DateTimeColumn get arrivedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get duration => integer().nullable()(); // seconds spent
  BoolColumn get scanVerified => boolean().withDefault(const Constant(false))();
  // scanMethod: qr, nfc, manual
  TextColumn get scanMethod => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  BoolColumn get withinGeofence => boolean().withDefault(const Constant(true))();
  TextColumn get photoLocalPath => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  // status: pending, arrived, completed, skipped
  TextColumn get status => text().withDefault(const Constant('pending'))();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Patrol task responses - responses to tasks at each point
class PatrolTaskResponses extends Table {
  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get tenantId => text()();
  TextColumn get pointCompletionId => text()();
  TextColumn get patrolTaskId => text()();
  TextColumn get responseValue => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

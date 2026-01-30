import 'package:drift/drift.dart';

/// In-app notifications table for notification center
class InAppNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get tenantId => text()();
  TextColumn get employeeId => text()();

  // Notification metadata
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get type =>
      text()(); // check_call, shift, patrol, incident, general
  TextColumn get priority => text().withDefault(
    const Constant('normal'),
  )(); // low, normal, high, urgent

  // Related entity references
  TextColumn get relatedEntityType =>
      text().nullable()(); // shift, check_call, patrol, etc.
  TextColumn get relatedEntityId => text().nullable()();

  // Display data
  TextColumn get iconType =>
      text().nullable()(); // bell, calendar, location, warning, info
  TextColumn get actionLabel =>
      text().nullable()(); // "View Shift", "Respond", etc.
  TextColumn get actionRoute => text().nullable()(); // Deep link route

  // Status tracking
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();

  // Timestamps
  DateTimeColumn get receivedAt => dateTime()();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  // Sync
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

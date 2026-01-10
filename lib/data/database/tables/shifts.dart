import 'package:drift/drift.dart';

class Shifts extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get employeeId => text()();
  TextColumn get siteId => text()();
  TextColumn get clientId => text()();

  // Site information (denormalized for offline use)
  TextColumn get siteName => text()();
  TextColumn get siteAddress => text()();
  RealColumn get siteLatitude => real().nullable()();
  RealColumn get siteLongitude => real().nullable()();

  // Client information
  TextColumn get clientName => text()();

  // Shift details
  DateTimeColumn get shiftDate => dateTime()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get breakMinutes => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();

  // Check call settings
  BoolColumn get checkCallEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get checkCallFrequency => integer().nullable()();

  // Metadata
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

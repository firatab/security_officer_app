import 'package:drift/drift.dart';

class Attendances extends Table {
  TextColumn get id => text()();
  TextColumn get shiftId => text()();
  TextColumn get employeeId => text()();
  TextColumn get tenantId => text()();

  // Book On details
  DateTimeColumn get bookOnTime => dateTime().nullable()();
  RealColumn get bookOnLatitude => real().nullable()();
  RealColumn get bookOnLongitude => real().nullable()();
  TextColumn get bookOnMethod => text().nullable()();

  // Book Off details
  DateTimeColumn get bookOffTime => dateTime().nullable()();
  RealColumn get bookOffLatitude => real().nullable()();
  RealColumn get bookOffLongitude => real().nullable()();
  TextColumn get bookOffMethod => text().nullable()();

  // Status and calculations
  TextColumn get status => text().withDefault(const Constant('pending'))();
  RealColumn get totalHours => real().nullable()();
  BoolColumn get isLate => boolean().withDefault(const Constant(false))();
  IntColumn get lateMinutes => integer().nullable()();
  BoolColumn get autoBookedOff => boolean().withDefault(const Constant(false))();

  // Metadata
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

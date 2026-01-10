import 'package:drift/drift.dart';

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

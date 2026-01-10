import 'package:drift/drift.dart';

@DataClassName('IncidentReport')
class IncidentReports extends Table {
  TextColumn get id => text()();
  TextColumn get shiftId => text()();
  TextColumn get employeeId => text()();
  TextColumn get tenantId => text()();
  DateTimeColumn get reportTime => dateTime()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get incidentType => text()();
  TextColumn get description => text()();
  TextColumn get severity => text()();
  TextColumn get mediaFilePaths => text().nullable()(); // Stored as JSON string
  TextColumn get mediaUrls => text().nullable()();      // Stored as JSON string
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

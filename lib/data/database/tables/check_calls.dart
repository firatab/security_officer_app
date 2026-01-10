import 'package:drift/drift.dart';

class CheckCalls extends Table {
  TextColumn get id => text()();
  TextColumn get shiftId => text()();
  TextColumn get employeeId => text()();
  TextColumn get tenantId => text()();

  DateTimeColumn get scheduledTime => dateTime()();
  DateTimeColumn get respondedAt => dateTime().nullable()();

  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, answered, missed
  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

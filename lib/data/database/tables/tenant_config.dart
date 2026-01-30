import 'package:drift/drift.dart';

/// Tenant configuration table
/// Stores tenant-specific settings including API URLs and branding
class TenantConfig extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Tenant identifier from backend
  TextColumn get tenantId => text()();

  /// Tenant display name
  TextColumn get tenantName => text()();

  /// Short tenant code for easy setup
  TextColumn get tenantCode => text().nullable()();

  /// Base URL for REST API
  TextColumn get apiBaseUrl => text()();

  /// Base URL for WebSocket connection
  TextColumn get wsBaseUrl => text()();

  /// Environment (prod, stage, dev)
  TextColumn get environment => text().withDefault(const Constant('prod'))();

  /// Branding configuration JSON (logo, theme colors, etc.)
  TextColumn get brandingJson => text().nullable()();

  /// Whether this tenant config is currently active
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  /// Timestamp when config was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when config was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// App-level configuration table
/// Stores app settings that aren't tenant-specific
class AppConfig extends Table {
  /// Configuration key
  TextColumn get key => text()();

  /// Configuration value (JSON-encoded for complex values)
  TextColumn get value => text()();

  /// Timestamp when config was updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

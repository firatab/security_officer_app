part of '../app_database.dart';

/// Data Access Object for tenant configuration operations
@DriftAccessor(tables: [TenantConfig, AppConfig])
class TenantConfigDao extends DatabaseAccessor<AppDatabase>
    with _$TenantConfigDaoMixin {
  TenantConfigDao(super.db);

  /// Get the currently active tenant configuration
  Future<TenantConfigData?> getActiveTenant() async {
    return (select(tenantConfig)
          ..where((t) => t.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get tenant by ID
  Future<TenantConfigData?> getTenantById(String tenantId) async {
    return (select(
      tenantConfig,
    )..where((t) => t.tenantId.equals(tenantId))).getSingleOrNull();
  }

  /// Get tenant by code
  Future<TenantConfigData?> getTenantByCode(String code) async {
    return (select(
      tenantConfig,
    )..where((t) => t.tenantCode.equals(code))).getSingleOrNull();
  }

  /// Get all saved tenants
  Future<List<TenantConfigData>> getAllTenants() {
    return select(tenantConfig).get();
  }

  /// Save or update tenant configuration
  Future<int> saveTenant(TenantConfigCompanion tenant) async {
    return into(tenantConfig).insertOnConflictUpdate(tenant);
  }

  /// Set a tenant as active (and deactivate others)
  Future<void> setActiveTenant(int tenantIdPk) async {
    await transaction(() async {
      // Deactivate all tenants
      await (update(tenantConfig)..where((t) => t.isActive.equals(true))).write(
        const TenantConfigCompanion(isActive: Value(false)),
      );

      // Activate the selected tenant
      await (update(tenantConfig)..where((t) => t.id.equals(tenantIdPk))).write(
        TenantConfigCompanion(
          isActive: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  /// Delete a tenant configuration
  Future<int> deleteTenant(int id) async {
    return (delete(tenantConfig)..where((t) => t.id.equals(id))).go();
  }

  /// Get app configuration value
  Future<String?> getAppConfig(String key) async {
    final result = await (select(
      appConfig,
    )..where((c) => c.key.equals(key))).getSingleOrNull();
    return result?.value;
  }

  /// Set app configuration value
  Future<void> setAppConfig(String key, String value) async {
    await into(appConfig).insertOnConflictUpdate(
      AppConfigCompanion.insert(
        key: key,
        value: value,
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete app configuration
  Future<int> deleteAppConfig(String key) async {
    return (delete(appConfig)..where((c) => c.key.equals(key))).go();
  }

  /// Clear all tenant data (for logout/switch)
  Future<void> clearAllTenantData() async {
    await delete(tenantConfig).go();
    await delete(appConfig).go();
  }
}

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import '../data/database/app_database.dart';
import '../core/services/tenant_discovery_service.dart';
import '../core/utils/logger.dart';

/// Tenant Service
/// Handles tenant configuration, validation, and management
/// Uses TenantDiscoveryService for robust multi-server discovery
class TenantService {
  final Dio _dio;
  final AppDatabase _database;

  TenantService(this._dio, this._database);

  /// Validate and fetch tenant configuration by code
  /// Uses TenantDiscoveryService to try multiple bootstrap servers
  Future<TenantConfigData> validateTenantCode(String code) async {
    try {
      AppLogger.info('Validating tenant code: $code');

      // Use discovery service to find tenant across multiple servers
      final result = await TenantDiscoveryService.discoverByCode(code);

      if (!result.success) {
        throw Exception(result.errorMessage ?? 'Failed to validate tenant code');
      }

      final data = result.tenantData!;

      // Create tenant config from response
      final tenant = TenantConfigCompanion.insert(
        tenantId: data['tenantId'] as String,
        tenantName: data['tenantName'] as String,
        tenantCode: Value(code),
        apiBaseUrl: result.serverUrl!,
        wsBaseUrl: result.wsUrl!,
        environment: Value(data['environment'] as String? ?? 'prod'),
        brandingJson: Value(data['branding'] as String?),
      );

      // Save to database
      await _database.tenantConfigDao.saveTenant(tenant);

      // Update Dio base URL for future requests
      _dio.options.baseUrl = result.serverUrl!;

      // Get and return saved tenant
      final savedTenant = await _database.tenantConfigDao.getTenantByCode(code);
      if (savedTenant == null) {
        throw Exception('Failed to save tenant configuration');
      }

      AppLogger.info('Tenant validated and saved: ${savedTenant.tenantName}');
      return savedTenant;
    } catch (e) {
      AppLogger.error('Tenant validation failed', e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to validate tenant: $e');
    }
  }

  /// Validate and fetch tenant configuration by URL
  /// Uses TenantDiscoveryService for proper URL validation
  Future<TenantConfigData> validateTenantUrl(String url) async {
    try {
      AppLogger.info('Validating tenant URL: $url');

      // Use discovery service to validate URL
      final result = await TenantDiscoveryService.discoverByUrl(url);

      if (!result.success) {
        throw Exception(result.errorMessage ?? 'Failed to validate tenant URL');
      }

      final data = result.tenantData!;

      // Create tenant config from response
      final tenant = TenantConfigCompanion.insert(
        tenantId: data['tenantId'] as String,
        tenantName: data['tenantName'] as String,
        tenantCode: Value(data['tenantCode'] as String?),
        apiBaseUrl: result.serverUrl!,
        wsBaseUrl: result.wsUrl!,
        environment: Value(data['environment'] as String? ?? 'prod'),
        brandingJson: Value(data['branding'] as String?),
      );

      // Save to database
      await _database.tenantConfigDao.saveTenant(tenant);

      // Update Dio base URL for future requests
      _dio.options.baseUrl = result.serverUrl!;

      // Get and return saved tenant
      final savedTenant = await _database.tenantConfigDao.getTenantById(
        data['tenantId'],
      );
      if (savedTenant == null) {
        throw Exception('Failed to save tenant configuration');
      }

      AppLogger.info('Tenant validated and saved: ${savedTenant.tenantName}');
      return savedTenant;
    } catch (e) {
      AppLogger.error('Tenant URL validation failed', e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to validate tenant URL: $e');
    }
  }

  /// Validate tenant from QR code data
  /// QR codes can contain tenant codes, URLs, or JSON configs
  Future<TenantConfigData> validateFromQRCode(String qrData) async {
    try {
      AppLogger.info('Validating tenant from QR code');

      // Use discovery service to parse and validate QR data
      final result = await TenantDiscoveryService.discoverByQRCode(qrData);

      if (!result.success) {
        throw Exception(result.errorMessage ?? 'Failed to validate QR code');
      }

      final data = result.tenantData!;

      // Create tenant config from response
      final tenant = TenantConfigCompanion.insert(
        tenantId: data['tenantId'] as String,
        tenantName: data['tenantName'] as String,
        tenantCode: Value(data['tenantCode'] as String?),
        apiBaseUrl: result.serverUrl!,
        wsBaseUrl: result.wsUrl!,
        environment: Value(data['environment'] as String? ?? 'prod'),
        brandingJson: Value(data['branding'] as String?),
      );

      // Save to database
      await _database.tenantConfigDao.saveTenant(tenant);

      // Update Dio base URL for future requests
      _dio.options.baseUrl = result.serverUrl!;

      // Get and return saved tenant
      final savedTenant = await _database.tenantConfigDao.getTenantById(
        data['tenantId'],
      );
      if (savedTenant == null) {
        throw Exception('Failed to save tenant configuration');
      }

      AppLogger.info('Tenant validated from QR: ${savedTenant.tenantName}');
      return savedTenant;
    } catch (e) {
      AppLogger.error('QR code validation failed', e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to validate QR code: $e');
    }
  }

  /// Get currently active tenant
  Future<TenantConfigData?> getActiveTenant() async {
    return await _database.tenantConfigDao.getActiveTenant();
  }

  /// Set tenant as active
  Future<void> setActiveTenant(int tenantId) async {
    await _database.tenantConfigDao.setActiveTenant(tenantId);

    // Update Dio base URL for all future requests
    final activeTenant = await getActiveTenant();
    if (activeTenant != null) {
      _dio.options.baseUrl = activeTenant.apiBaseUrl;
    }
  }

  /// Get all saved tenants
  Future<List<TenantConfigData>> getAllTenants() async {
    return await _database.tenantConfigDao.getAllTenants();
  }

  /// Delete a tenant configuration
  Future<void> deleteTenant(int tenantId) async {
    await _database.tenantConfigDao.deleteTenant(tenantId);
  }

  /// Clear all tenant data (for logout/reset)
  Future<void> clearAllTenantData() async {
    await _database.tenantConfigDao.clearAllTenantData();
  }

  /// Check if tenant is configured
  Future<bool> isTenantConfigured() async {
    final tenant = await getActiveTenant();
    return tenant != null;
  }
}

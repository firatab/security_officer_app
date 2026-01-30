import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../main.dart'; // For dioClientProvider and databaseProvider
import '../../data/database/app_database.dart';
import '../../services/tenant_service.dart';

part 'tenant_provider.g.dart';

/// Tenant Service Provider
@riverpod
TenantService tenantService(TenantServiceRef ref) {
  final dio = ref.watch(dioClientProvider);
  final database = ref.watch(databaseProvider);
  return TenantService(dio.dio, database);
}

/// Active Tenant Provider
/// Watches the currently active tenant configuration
@riverpod
Future<TenantConfigData?> activeTenant(ActiveTenantRef ref) async {
  final tenantService = ref.watch(tenantServiceProvider);
  return await tenantService.getActiveTenant();
}

/// All Tenants Provider
/// Returns list of all saved tenant configurations
@riverpod
Future<List<TenantConfigData>> allTenants(AllTenantsRef ref) async {
  final tenantService = ref.watch(tenantServiceProvider);
  return await tenantService.getAllTenants();
}

/// Tenant Configured Provider
/// Checks if a tenant is configured
@riverpod
Future<bool> isTenantConfigured(IsTenantConfiguredRef ref) async {
  final tenantService = ref.watch(tenantServiceProvider);
  return await tenantService.isTenantConfigured();
}

/// Tenant Setup State
/// State management for tenant setup process
class TenantSetupState {
  final bool isLoading;
  final String? errorMessage;
  final TenantConfigData? tenant;

  const TenantSetupState({
    this.isLoading = false,
    this.errorMessage,
    this.tenant,
  });

  TenantSetupState copyWith({
    bool? isLoading,
    String? errorMessage,
    TenantConfigData? tenant,
    bool clearTenant = false,
    bool clearError = false,
  }) {
    return TenantSetupState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      tenant: clearTenant ? null : (tenant ?? this.tenant),
    );
  }
}

/// Tenant Setup Notifier
@riverpod
class TenantSetup extends _$TenantSetup {
  @override
  TenantSetupState build() {
    return const TenantSetupState();
  }

  /// Validate tenant by code
  Future<void> validateByCode(String code) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearTenant: true,
    );

    try {
      final tenantService = ref.read(tenantServiceProvider);
      final tenant = await tenantService.validateTenantCode(code);

      // Set as active tenant
      await tenantService.setActiveTenant(tenant.id);

      // Invalidate tenant providers to refresh
      ref.invalidate(activeTenantProvider);
      ref.invalidate(isTenantConfiguredProvider);

      state = state.copyWith(
        isLoading: false,
        tenant: tenant,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getReadableErrorMessage(e),
        clearTenant: true,
      );
    }
  }

  /// Validate tenant by URL
  Future<void> validateByUrl(String url) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearTenant: true,
    );

    try {
      final tenantService = ref.read(tenantServiceProvider);
      final tenant = await tenantService.validateTenantUrl(url);

      // Set as active tenant
      await tenantService.setActiveTenant(tenant.id);

      // Invalidate tenant providers to refresh
      ref.invalidate(activeTenantProvider);
      ref.invalidate(isTenantConfiguredProvider);

      state = state.copyWith(
        isLoading: false,
        tenant: tenant,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getReadableErrorMessage(e),
        clearTenant: true,
      );
    }
  }

  /// Validate tenant from QR code
  /// QR codes can contain tenant codes, URLs, or JSON configurations
  Future<void> validateFromQRCode(String qrData) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearTenant: true,
    );

    try {
      final tenantService = ref.read(tenantServiceProvider);
      final tenant = await tenantService.validateFromQRCode(qrData);

      // Set as active tenant
      await tenantService.setActiveTenant(tenant.id);

      // Invalidate tenant providers to refresh
      ref.invalidate(activeTenantProvider);
      ref.invalidate(isTenantConfiguredProvider);

      state = state.copyWith(
        isLoading: false,
        tenant: tenant,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getReadableErrorMessage(e),
        clearTenant: true,
      );
    }
  }

  /// Switch to a different tenant
  Future<void> switchTenant(int tenantId) async {
    state = state.copyWith(isLoading: true);

    try {
      final tenantService = ref.read(tenantServiceProvider);
      await tenantService.setActiveTenant(tenantId);

      // Invalidate providers
      ref.invalidate(activeTenantProvider);

      final tenant = await tenantService.getActiveTenant();
      state = state.copyWith(
        isLoading: false,
        tenant: tenant,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getReadableErrorMessage(e),
        clearTenant: true,
      );
    }
  }

  /// Reset state
  void reset() {
    state = const TenantSetupState();
  }

  String _getReadableErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring(11);
    }
    return message;
  }
}

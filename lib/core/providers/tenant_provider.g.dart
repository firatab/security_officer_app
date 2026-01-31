// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tenantServiceHash() => r'f93ea5c412bb9b112b3e5ad8a81fd8116a10b78c';

/// Tenant Service Provider
///
/// Copied from [tenantService].
@ProviderFor(tenantService)
final tenantServiceProvider = AutoDisposeProvider<TenantService>.internal(
  tenantService,
  name: r'tenantServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tenantServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TenantServiceRef = AutoDisposeProviderRef<TenantService>;
String _$activeTenantHash() => r'2631575d162517ad18de236bf6cddcb2589ac77a';

/// Active Tenant Provider
/// Watches the currently active tenant configuration
///
/// Copied from [activeTenant].
@ProviderFor(activeTenant)
final activeTenantProvider =
    AutoDisposeFutureProvider<TenantConfigData?>.internal(
      activeTenant,
      name: r'activeTenantProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeTenantHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveTenantRef = AutoDisposeFutureProviderRef<TenantConfigData?>;
String _$allTenantsHash() => r'4dc56cdbe99996b30a3ec7d5e49376f74d411e59';

/// All Tenants Provider
/// Returns list of all saved tenant configurations
///
/// Copied from [allTenants].
@ProviderFor(allTenants)
final allTenantsProvider =
    AutoDisposeFutureProvider<List<TenantConfigData>>.internal(
      allTenants,
      name: r'allTenantsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allTenantsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllTenantsRef = AutoDisposeFutureProviderRef<List<TenantConfigData>>;
String _$isTenantConfiguredHash() =>
    r'3f0116cda43b819cd69a10476121eaab446f1f5f';

/// Tenant Configured Provider
/// Checks if a tenant is configured
///
/// Copied from [isTenantConfigured].
@ProviderFor(isTenantConfigured)
final isTenantConfiguredProvider = AutoDisposeFutureProvider<bool>.internal(
  isTenantConfigured,
  name: r'isTenantConfiguredProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isTenantConfiguredHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsTenantConfiguredRef = AutoDisposeFutureProviderRef<bool>;
String _$tenantSetupHash() => r'69b8bcac839e5ef75979350cbe70f780eb475b32';

/// Tenant Setup Notifier
///
/// Copied from [TenantSetup].
@ProviderFor(TenantSetup)
final tenantSetupProvider =
    AutoDisposeNotifierProvider<TenantSetup, TenantSetupState>.internal(
      TenantSetup.new,
      name: r'tenantSetupProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tenantSetupHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TenantSetup = AutoDisposeNotifier<TenantSetupState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

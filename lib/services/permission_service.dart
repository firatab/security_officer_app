import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/utils/logger.dart';

/// Permission status for the app
class AppPermissionStatus {
  final bool locationGranted;
  final bool locationAlwaysGranted;
  final bool cameraGranted;
  final bool notificationGranted;
  final bool storageGranted;
  final bool locationServiceEnabled;

  AppPermissionStatus({
    this.locationGranted = false,
    this.locationAlwaysGranted = false,
    this.cameraGranted = false,
    this.notificationGranted = false,
    this.storageGranted = false,
    this.locationServiceEnabled = false,
  });

  bool get allRequiredGranted =>
      locationGranted && cameraGranted && notificationGranted && locationServiceEnabled;

  bool get allGranted =>
      locationGranted &&
      locationAlwaysGranted &&
      cameraGranted &&
      notificationGranted &&
      storageGranted &&
      locationServiceEnabled;

  List<String> get missingPermissions {
    final missing = <String>[];
    if (!locationServiceEnabled) missing.add('Location Services');
    if (!locationGranted) missing.add('Location');
    if (!cameraGranted) missing.add('Camera');
    if (!notificationGranted) missing.add('Notifications');
    if (!storageGranted) missing.add('Storage');
    return missing;
  }

  AppPermissionStatus copyWith({
    bool? locationGranted,
    bool? locationAlwaysGranted,
    bool? cameraGranted,
    bool? notificationGranted,
    bool? storageGranted,
    bool? locationServiceEnabled,
  }) {
    return AppPermissionStatus(
      locationGranted: locationGranted ?? this.locationGranted,
      locationAlwaysGranted: locationAlwaysGranted ?? this.locationAlwaysGranted,
      cameraGranted: cameraGranted ?? this.cameraGranted,
      notificationGranted: notificationGranted ?? this.notificationGranted,
      storageGranted: storageGranted ?? this.storageGranted,
      locationServiceEnabled: locationServiceEnabled ?? this.locationServiceEnabled,
    );
  }
}

/// Service to handle all app permissions
class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Check all permissions without requesting
  Future<AppPermissionStatus> checkAllPermissions() async {
    AppLogger.info('Checking all permissions...');

    // Check location service
    final locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    // Check location permission
    final locationStatus = await Permission.location.status;
    final locationAlwaysStatus = await Permission.locationAlways.status;

    // Check camera permission
    final cameraStatus = await Permission.camera.status;

    // Check notification permission
    final notificationStatus = await Permission.notification.status;

    // Check storage permission (Android only)
    bool storageGranted = true;
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.status;
      final photosStatus = await Permission.photos.status;
      storageGranted = storageStatus.isGranted || photosStatus.isGranted;
    }

    final status = AppPermissionStatus(
      locationServiceEnabled: locationServiceEnabled,
      locationGranted: locationStatus.isGranted,
      locationAlwaysGranted: locationAlwaysStatus.isGranted,
      cameraGranted: cameraStatus.isGranted,
      notificationGranted: notificationStatus.isGranted,
      storageGranted: storageGranted,
    );

    AppLogger.info('Permission status: '
        'location=${status.locationGranted}, '
        'locationAlways=${status.locationAlwaysGranted}, '
        'camera=${status.cameraGranted}, '
        'notification=${status.notificationGranted}, '
        'storage=${status.storageGranted}, '
        'locationService=${status.locationServiceEnabled}');

    return status;
  }

  /// Request all required permissions
  Future<AppPermissionStatus> requestAllPermissions() async {
    AppLogger.info('Requesting all permissions...');

    // Request location permission first
    var locationStatus = await Permission.location.request();
    AppLogger.info('Location permission: $locationStatus');

    // If location granted, request always permission for background tracking
    var locationAlwaysStatus = PermissionStatus.denied;
    if (locationStatus.isGranted) {
      locationAlwaysStatus = await Permission.locationAlways.request();
      AppLogger.info('Location always permission: $locationAlwaysStatus');
    }

    // Request camera permission
    final cameraStatus = await Permission.camera.request();
    AppLogger.info('Camera permission: $cameraStatus');

    // Request notification permission
    final notificationStatus = await Permission.notification.request();
    AppLogger.info('Notification permission: $notificationStatus');

    // Request storage permission (Android only)
    bool storageGranted = true;
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        final photosStatus = await Permission.photos.request();
        storageGranted = photosStatus.isGranted;
      } else {
        storageGranted = true;
      }
      AppLogger.info('Storage permission: $storageGranted');
    }

    // Check location service
    final locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    return AppPermissionStatus(
      locationServiceEnabled: locationServiceEnabled,
      locationGranted: locationStatus.isGranted,
      locationAlwaysGranted: locationAlwaysStatus.isGranted,
      cameraGranted: cameraStatus.isGranted,
      notificationGranted: notificationStatus.isGranted,
      storageGranted: storageGranted,
    );
  }

  /// Request a specific permission
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Open app settings
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Check if permission is permanently denied
  Future<bool> isPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }
}

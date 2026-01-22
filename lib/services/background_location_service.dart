import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart' show LazyDatabase;
import 'package:drift/native.dart';

/// Background location tracking service
class BackgroundLocationService {
  static final BackgroundLocationService _instance = BackgroundLocationService._internal();
  factory BackgroundLocationService() => _instance;
  BackgroundLocationService._internal();

  final FlutterBackgroundService _service = FlutterBackgroundService();
  bool _isInitialized = false;

  /// Initialize the background service
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: AppConstants.locationChannelId,
        initialNotificationTitle: 'SentraGuard',
        initialNotificationContent: 'Location tracking active',
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    _isInitialized = true;
    AppLogger.info('Background location service initialized');
  }

  /// Start location tracking
  Future<bool> startTracking({
    required String employeeId,
    required String tenantId,
    String? shiftId,
  }) async {
    try {
      // Get database path for background isolate
      String dbPath = '';
      try {
        final dir = await getApplicationDocumentsDirectory();
        dbPath = '${dir.path}/security_officer_db.sqlite';
      } catch (e) {
        AppLogger.warning('Could not get database path: $e');
      }

      // Save tracking info to shared preferences for background isolate
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('tracking_employee_id', employeeId);
      await prefs.setString('tracking_tenant_id', tenantId);
      await prefs.setString('tracking_db_path', dbPath);
      if (shiftId != null) {
        await prefs.setString('tracking_shift_id', shiftId);
      } else {
        await prefs.remove('tracking_shift_id');
      }
      await prefs.setBool('tracking_active', true);

      // Start the service
      final started = await _service.startService();

      if (started) {
        AppLogger.info('Background location tracking started for employee: $employeeId');
      } else {
        AppLogger.error('Failed to start background location tracking');
      }

      return started;
    } catch (e) {
      AppLogger.error('Error starting location tracking', e);
      return false;
    }
  }

  /// Stop location tracking
  Future<void> stopTracking() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tracking_active', false);
      await prefs.remove('tracking_shift_id');

      _service.invoke('stop');
      AppLogger.info('Background location tracking stopped');
    } catch (e) {
      AppLogger.error('Error stopping location tracking', e);
    }
  }

  /// Check if tracking is active
  Future<bool> isTrackingActive() async {
    return await _service.isRunning();
  }

  /// Update shift ID for tracking
  Future<void> updateShiftId(String? shiftId) async {
    final prefs = await SharedPreferences.getInstance();
    if (shiftId != null) {
      await prefs.setString('tracking_shift_id', shiftId);
    } else {
      await prefs.remove('tracking_shift_id');
    }
    _service.invoke('updateShift', {'shiftId': shiftId});
  }

  /// Get tracking status stream
  Stream<Map<String, dynamic>?> get statusStream {
    return _service.on('status');
  }
}

/// Background service entry point - runs in isolate
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  // Ensure Flutter bindings are initialized for background isolate
  // This MUST be called first before anything else
  WidgetsFlutterBinding.ensureInitialized();

  // Note: DartPluginRegistrant.ensureInitialized() is NOT called here
  // as it can cause crashes on some devices and is not required for
  // the plugins we use (geolocator, shared_preferences work without it)

  final uuid = const Uuid();
  FlutterLocalNotificationsPlugin? notificationsPlugin;
  LazyDatabase? lazyDatabase;
  StreamSubscription<Position>? locationSubscription;

  // Track if service is still running
  bool isRunning = true;

  // Get tracking info from shared preferences FIRST
  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (prefsError) {
    AppLogger.error('Failed to get SharedPreferences', prefsError);
    // Cannot continue without shared preferences
    service.stopSelf();
    return;
  }

  final String? employeeId = prefs.getString('tracking_employee_id');
  final String? tenantId = prefs.getString('tracking_tenant_id');
  final String? dbPath = prefs.getString('tracking_db_path');
  String? shiftId = prefs.getString('tracking_shift_id');

  // Validate required data before proceeding
  if (employeeId == null || tenantId == null || employeeId.isEmpty || tenantId.isEmpty) {
    AppLogger.error('Missing employeeId or tenantId for location tracking');
    service.stopSelf();
    return;
  }

  // IMPORTANT: Set as foreground service EARLY to prevent Android from killing the service
  // This must happen before any long-running operations
  if (service is AndroidServiceInstance) {
    try {
      service.setAsForegroundService();
      AppLogger.info('Background service set as foreground');
    } catch (fgError) {
      AppLogger.error('Failed to set foreground service', fgError);
    }
  }

  // Initialize notifications with error handling
  try {
    notificationsPlugin = FlutterLocalNotificationsPlugin();

    await notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    // Note: Notification channel is created in main app initialization (NotificationService)
    // before this background service starts, so we don't need to create it here
  } catch (notifError) {
    AppLogger.error('Failed to initialize notifications in background service', notifError);
    // Continue without notifications - location tracking is more important
  }

  // Initialize database using the path passed from main isolate
  // This is more reliable than trying to use driftDatabase() in a background isolate
  AppDatabase? database;
  if (dbPath != null && dbPath.isNotEmpty) {
    try {
      // Small delay to allow isolate to fully initialize
      await Future.delayed(const Duration(milliseconds: 300));

      // Create database using native connection with explicit path
      final file = File(dbPath);
      lazyDatabase = LazyDatabase(() async {
        return NativeDatabase.createInBackground(file);
      });
      database = AppDatabase.forTesting(lazyDatabase);
      AppLogger.info('Database initialized in background service with path: $dbPath');
    } catch (dbError) {
      AppLogger.error('Failed to initialize database in background service', dbError);
      // Continue without database - we'll store in shared preferences
      database = null;
    }
  } else {
    AppLogger.warning('No database path provided, will store locations in SharedPreferences');
  }

  // Store pending locations in memory if database fails
  List<Map<String, dynamic>> pendingLocations = [];

  // Helper function to save locations to SharedPreferences
  Future<void> savePendingToPrefs() async {
    if (pendingLocations.isEmpty) return;
    try {
      final pendingJson = pendingLocations.map((l) => jsonEncode(l)).toList();
      await prefs?.setStringList('pending_locations', pendingJson);
    } catch (e) {
      AppLogger.error('Failed to save pending locations to prefs', e);
    }
  }

  // Handle stop command
  service.on('stop').listen((event) async {
    isRunning = false;
    AppLogger.info('Stop command received');

    // Save any pending locations before stopping
    await savePendingToPrefs();

    // Cancel location subscription
    await locationSubscription?.cancel();
    locationSubscription = null;

    // Close database
    try {
      await database?.close();
    } catch (e) {
      // Ignore close errors
    }

    service.stopSelf();
    AppLogger.info('Background service stopped');
  });

  // Handle shift update
  service.on('updateShift').listen((event) {
    if (event != null && isRunning) {
      shiftId = event['shiftId'] as String?;
      AppLogger.debug('Shift ID updated to: $shiftId');
    }
  });

  // Start location tracking
  try {
    // Check location permission first
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      AppLogger.error('Location permission not granted: $permission');
      service.stopSelf();
      return;
    }

    // Check if location service is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppLogger.error('Location services are disabled');
      service.stopSelf();
      return;
    }

    // Use platform-specific settings for better background location tracking
    late final LocationSettings locationSettings;
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Only update if moved 10+ meters
        intervalDuration: Duration(seconds: AppConstants.locationUpdateIntervalSeconds),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'SentraGuard',
          notificationText: 'Location tracking active',
          enableWakeLock: true,
        ),
      );
    } else {
      // iOS or other platforms - use standard settings
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }

    int locationCount = 0;
    DateTime lastSave = DateTime.now();

    locationSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) async {
        if (!isRunning) return;

        final now = DateTime.now();

        // Save location every 15 seconds (or based on constant)
        if (now.difference(lastSave).inSeconds >= AppConstants.locationUpdateIntervalSeconds) {
          lastSave = now;
          locationCount++;

          final locationData = <String, dynamic>{
            'id': uuid.v4(),
            'employeeId': employeeId,
            'tenantId': tenantId,
            'shiftId': shiftId,
            'latitude': position.latitude,
            'longitude': position.longitude,
            'accuracy': position.accuracy,
            'altitude': position.altitude,
            'speed': position.speed,
            'timestamp': now.toIso8601String(),
          };

          try {
            if (database != null) {
              // Save to database
              final companion = LocationLogsCompanion.insert(
                id: locationData['id'] as String,
                employeeId: employeeId,
                tenantId: tenantId,
                shiftId: drift.Value(shiftId),
                latitude: position.latitude,
                longitude: position.longitude,
                accuracy: drift.Value(position.accuracy),
                altitude: drift.Value(position.altitude),
                speed: drift.Value(position.speed),
                timestamp: now,
                needsSync: const drift.Value(true),
              );

              await database.into(database.locationLogs).insert(companion);
              AppLogger.debug(
                'Location saved to DB: ${position.latitude}, ${position.longitude} (count: $locationCount)',
              );
            } else {
              // Store in memory if database not available
              pendingLocations.add(locationData);

              // Save to SharedPreferences periodically (every 5 locations)
              if (pendingLocations.length % 5 == 0) {
                await savePendingToPrefs();
              }

              AppLogger.debug(
                'Location saved to memory: ${position.latitude}, ${position.longitude} (count: $locationCount)',
              );
            }

            // Update notification
            if (service is AndroidServiceInstance) {
              service.setForegroundNotificationInfo(
                title: 'SentraGuard - Tracking',
                content: 'Location updated: ${now.hour}:${now.minute.toString().padLeft(2, '0')} ($locationCount points)',
              );
            }

            // Send status update to main isolate
            service.invoke('status', {
              'latitude': position.latitude,
              'longitude': position.longitude,
              'accuracy': position.accuracy,
              'timestamp': now.toIso8601String(),
              'count': locationCount,
            });
          } catch (e) {
            AppLogger.error('Error saving location', e);
            // Try to save to pending on error
            if (!pendingLocations.contains(locationData)) {
              pendingLocations.add(locationData);
            }
          }
        }
      },
      onError: (dynamic error) {
        AppLogger.error('Location stream error', error);
        // Don't stop service on stream error, it might recover
      },
      cancelOnError: false,
    );

    AppLogger.info('Background location service started successfully for employee: $employeeId');
  } catch (locationError) {
    AppLogger.error('Failed to start location stream', locationError);
    // Save any pending locations before stopping
    await savePendingToPrefs();
    service.stopSelf();
  }
}

/// iOS background handler
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  // On iOS, the main onStart handler will be called
  // This just needs to return true to allow background execution
  return true;
}

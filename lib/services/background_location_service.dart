import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

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
        initialNotificationTitle: 'Security Officer',
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
      // Save tracking info to shared preferences for background isolate
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('tracking_employee_id', employeeId);
      await prefs.setString('tracking_tenant_id', tenantId);
      if (shiftId != null) {
        await prefs.setString('tracking_shift_id', shiftId);
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
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  await notificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  // Create notification channel for Android
  if (service is AndroidServiceInstance) {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            AppConstants.locationChannelId,
            AppConstants.locationChannelName,
            description: 'Used for location tracking during shifts',
            importance: Importance.low,
          ),
        );
  }

  // Initialize database in isolate
  final database = AppDatabase();
  final uuid = const Uuid();

  // Get tracking info from shared preferences
  final prefs = await SharedPreferences.getInstance();
  String? employeeId = prefs.getString('tracking_employee_id');
  String? tenantId = prefs.getString('tracking_tenant_id');
  String? shiftId = prefs.getString('tracking_shift_id');

  // Location stream subscription
  StreamSubscription<Position>? locationSubscription;

  // Handle stop command
  service.on('stop').listen((event) {
    locationSubscription?.cancel();
    service.stopSelf();
    AppLogger.info('Background service stopped');
  });

  // Handle shift update
  service.on('updateShift').listen((event) {
    if (event != null) {
      shiftId = event['shiftId'];
      AppLogger.debug('Shift ID updated to: $shiftId');
    }
  });

  // Start location tracking
  if (employeeId != null && tenantId != null) {
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Only update if moved 10+ meters
    );

    int locationCount = 0;
    DateTime lastSave = DateTime.now();

    locationSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) async {
      final now = DateTime.now();

      // Save location every 15 seconds (or based on constant)
      if (now.difference(lastSave).inSeconds >= AppConstants.locationUpdateIntervalSeconds) {
        lastSave = now;
        locationCount++;

        try {
          // Save to database
          final companion = LocationLogsCompanion.insert(
            id: uuid.v4(),
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
            'Location saved: ${position.latitude}, ${position.longitude} (count: $locationCount)',
          );

          // Update notification
          if (service is AndroidServiceInstance) {
            service.setForegroundNotificationInfo(
              title: 'Security Officer - Tracking',
              content: 'Location updated: ${now.hour}:${now.minute.toString().padLeft(2, '0')} ($locationCount points)',
            );
          }

          // Send status update
          service.invoke('status', {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'accuracy': position.accuracy,
            'timestamp': now.toIso8601String(),
            'count': locationCount,
          });
        } catch (e) {
          AppLogger.error('Error saving location', e);
        }
      }
    }, onError: (e) {
      AppLogger.error('Location stream error', e);
    });
  }

  // Keep service running
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }
}

/// iOS background handler
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

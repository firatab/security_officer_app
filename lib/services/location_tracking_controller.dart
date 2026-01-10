import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../core/utils/logger.dart';
import 'background_location_service.dart';
import 'location_service.dart';

/// Location tracking state
class LocationTrackingState {
  final bool isTracking;
  final bool isInitialized;
  final Position? lastPosition;
  final DateTime? lastUpdate;
  final int locationCount;
  final String? error;
  final String? currentShiftId;

  LocationTrackingState({
    this.isTracking = false,
    this.isInitialized = false,
    this.lastPosition,
    this.lastUpdate,
    this.locationCount = 0,
    this.error,
    this.currentShiftId,
  });

  LocationTrackingState copyWith({
    bool? isTracking,
    bool? isInitialized,
    Position? lastPosition,
    DateTime? lastUpdate,
    int? locationCount,
    String? error,
    String? currentShiftId,
  }) {
    return LocationTrackingState(
      isTracking: isTracking ?? this.isTracking,
      isInitialized: isInitialized ?? this.isInitialized,
      lastPosition: lastPosition ?? this.lastPosition,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      locationCount: locationCount ?? this.locationCount,
      error: error,
      currentShiftId: currentShiftId ?? this.currentShiftId,
    );
  }
}

/// Location tracking controller using Riverpod
class LocationTrackingController extends StateNotifier<LocationTrackingState> {
  final BackgroundLocationService _backgroundService;
  final LocationService _locationService;
  StreamSubscription<Map<String, dynamic>?>? _statusSubscription;

  LocationTrackingController(this._backgroundService, this._locationService)
      : super(LocationTrackingState());

  /// Initialize the tracking service
  Future<void> initialize() async {
    if (state.isInitialized) return;

    try {
      await _backgroundService.initialize();

      // Listen to status updates from background service
      _statusSubscription = _backgroundService.statusStream.listen((status) {
        if (status != null) {
          state = state.copyWith(
            lastPosition: Position(
              latitude: status['latitude'] ?? 0.0,
              longitude: status['longitude'] ?? 0.0,
              accuracy: status['accuracy'] ?? 0.0,
              altitude: 0.0,
              altitudeAccuracy: 0.0,
              heading: 0.0,
              headingAccuracy: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
              timestamp: DateTime.tryParse(status['timestamp'] ?? '') ?? DateTime.now(),
            ),
            lastUpdate: DateTime.tryParse(status['timestamp'] ?? ''),
            locationCount: status['count'] ?? 0,
          );
        }
      });

      // Check if already tracking
      final isRunning = await _backgroundService.isTrackingActive();

      state = state.copyWith(
        isInitialized: true,
        isTracking: isRunning,
      );

      AppLogger.info('Location tracking controller initialized');
    } catch (e) {
      AppLogger.error('Error initializing location tracking', e);
      state = state.copyWith(
        error: 'Failed to initialize location tracking: $e',
      );
    }
  }

  /// Start tracking for a shift
  Future<bool> startTracking({
    required String employeeId,
    required String tenantId,
    String? shiftId,
  }) async {
    try {
      // Check location permission first
      final permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await _locationService.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          state = state.copyWith(
            error: 'Location permission denied',
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          error: 'Location permission permanently denied. Please enable in settings.',
        );
        return false;
      }

      // Check if location services are enabled
      if (!await _locationService.isLocationServiceEnabled()) {
        state = state.copyWith(
          error: 'Location services are disabled',
        );
        return false;
      }

      // Start background tracking
      final started = await _backgroundService.startTracking(
        employeeId: employeeId,
        tenantId: tenantId,
        shiftId: shiftId,
      );

      if (started) {
        state = state.copyWith(
          isTracking: true,
          currentShiftId: shiftId,
          error: null,
          locationCount: 0,
        );
        AppLogger.info('Location tracking started');
      } else {
        state = state.copyWith(
          error: 'Failed to start tracking service',
        );
      }

      return started;
    } catch (e) {
      AppLogger.error('Error starting tracking', e);
      state = state.copyWith(
        error: 'Error starting tracking: $e',
      );
      return false;
    }
  }

  /// Stop tracking
  Future<void> stopTracking() async {
    try {
      await _backgroundService.stopTracking();
      state = state.copyWith(
        isTracking: false,
        currentShiftId: null,
        error: null,
      );
      AppLogger.info('Location tracking stopped');
    } catch (e) {
      AppLogger.error('Error stopping tracking', e);
      state = state.copyWith(
        error: 'Error stopping tracking: $e',
      );
    }
  }

  /// Update current shift
  Future<void> updateShift(String? shiftId) async {
    try {
      await _backgroundService.updateShiftId(shiftId);
      state = state.copyWith(currentShiftId: shiftId);
    } catch (e) {
      AppLogger.error('Error updating shift', e);
    }
  }

  /// Get current location once
  Future<Position?> getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      state = state.copyWith(
        lastPosition: position,
        lastUpdate: DateTime.now(),
      );
      return position;
    } catch (e) {
      AppLogger.error('Error getting current location', e);
      state = state.copyWith(
        error: 'Error getting location: $e',
      );
      return null;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }
}

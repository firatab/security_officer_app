import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../core/utils/logger.dart';
import 'background_location_service.dart';
import 'location_service.dart';
import 'location_batch_manager.dart';

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
  final LocationBatchManager _batchManager;
  StreamSubscription<Map<String, dynamic>?>? _statusSubscription;

  LocationTrackingController(
    this._backgroundService,
    this._locationService,
    this._batchManager,
  ) : super(LocationTrackingState());

  /// Initialize the tracking service
  Future<void> initialize() async {
    if (state.isInitialized) return;

    try {
      await _backgroundService.initialize();

      // Listen to status updates from background service
      _statusSubscription = _backgroundService.statusStream.listen(
        (status) {
          if (status != null && status.isNotEmpty) {
            try {
              final lat = (status['latitude'] as num?)?.toDouble() ?? 0.0;
              final lng = (status['longitude'] as num?)?.toDouble() ?? 0.0;
              final acc = (status['accuracy'] as num?)?.toDouble() ?? 0.0;
              final timestampStr = status['timestamp'] as String?;
              final count = (status['count'] as int?) ?? 0;

              state = state.copyWith(
                lastPosition: Position(
                  latitude: lat,
                  longitude: lng,
                  accuracy: acc,
                  altitude: 0.0,
                  altitudeAccuracy: 0.0,
                  heading: 0.0,
                  headingAccuracy: 0.0,
                  speed: 0.0,
                  speedAccuracy: 0.0,
                  timestamp: timestampStr != null
                      ? DateTime.tryParse(timestampStr) ?? DateTime.now()
                      : DateTime.now(),
                ),
                lastUpdate: timestampStr != null
                    ? DateTime.tryParse(timestampStr)
                    : DateTime.now(),
                locationCount: count,
              );
            } catch (e) {
              AppLogger.error('Error processing location status', e);
            }
          }
        },
        onError: (dynamic error) {
          AppLogger.error('Status stream error', error);
        },
      );

      // Check if already tracking
      final isRunning = await _backgroundService.isTrackingActive();

      state = state.copyWith(isInitialized: true, isTracking: isRunning);

      AppLogger.info('Location tracking controller initialized');
    } catch (e) {
      AppLogger.error('Error initializing location tracking', e);
      state = state.copyWith(
        isInitialized:
            true, // Mark as initialized even on error to prevent retry loops
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
    // Validate inputs
    if (employeeId.isEmpty || tenantId.isEmpty) {
      state = state.copyWith(error: 'Invalid employee or tenant ID');
      return false;
    }

    try {
      // Check location permission first
      LocationPermission permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await _locationService.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          state = state.copyWith(
            error: 'Location permission denied. Please grant location access.',
          );
          return false;
        }
        permission = requested;
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          error:
              'Location permission permanently denied. Please enable in app settings.',
        );
        return false;
      }

      // Check if location services are enabled
      final serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          error: 'Location services are disabled. Please enable GPS.',
        );
        return false;
      }

      // Ensure background service is initialized
      if (!state.isInitialized) {
        await initialize();
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
        // Start batch sync manager
        _batchManager.startPeriodicSync();

        AppLogger.info('Location tracking started for employee: $employeeId');
      } else {
        state = state.copyWith(
          error: 'Failed to start tracking service. Please try again.',
        );
      }

      return started;
    } catch (e) {
      AppLogger.error('Error starting tracking', e);
      state = state.copyWith(
        error:
            'Error starting tracking: ${e.toString().replaceAll('Exception:', '').trim()}',
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

      // Stop batch sync and trigger final sync
      _batchManager.stop();
      _batchManager.syncNow();
    } catch (e) {
      AppLogger.error('Error stopping tracking', e);
      state = state.copyWith(error: 'Error stopping tracking: $e');
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
      state = state.copyWith(error: 'Error getting location: $e');
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

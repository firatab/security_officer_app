import 'dart:math' show cos, sqrt, asin, sin;
import 'package:geolocator/geolocator.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/exceptions.dart';
import '../core/utils/logger.dart';

class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current location
  Future<Position> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException(
          'Location services are disabled. Please enable location services in your device settings.',
        );
      }

      // Check permission
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException(
            'Location permission denied. Please grant location access to use this feature.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          'Location permission permanently denied. Please enable it in app settings.',
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      AppLogger.debug(
        'Location obtained: ${position.latitude}, ${position.longitude} (accuracy: ${position.accuracy}m)',
      );

      return position;
    } on LocationServiceDisabledException catch (e) {
      AppLogger.error('Location service disabled', e);
      throw LocationException('Location services are disabled');
    } on PermissionDeniedException catch (e) {
      AppLogger.error('Location permission denied', e);
      throw LocationException('Location permission denied');
    } catch (e) {
      AppLogger.error('Error getting location', e);
      throw LocationException('Failed to get location: $e');
    }
  }

  /// Calculate distance between two coordinates (in meters)
  /// Uses Haversine formula
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000; // meters
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2));

    final c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  /// Validate if current location is within geofence of target location
  Future<GeofenceValidation> validateGeofence({
    required double targetLat,
    required double targetLon,
    double? radiusMeters,
  }) async {
    try {
      final position = await getCurrentLocation();
      final distance = calculateDistance(
        position.latitude,
        position.longitude,
        targetLat,
        targetLon,
      );

      final radius = radiusMeters ?? AppConstants.geofenceRadiusMeters;
      final isWithin = distance <= radius;

      AppLogger.debug(
        'Geofence validation: distance=${distance.toStringAsFixed(1)}m, radius=${radius}m, within=$isWithin',
      );

      return GeofenceValidation(
        isWithinGeofence: isWithin,
        distance: distance,
        currentLatitude: position.latitude,
        currentLongitude: position.longitude,
        accuracy: position.accuracy,
      );
    } catch (e) {
      AppLogger.error('Geofence validation failed', e);
      rethrow;
    }
  }

  /// Start location tracking (for continuous tracking)
  Stream<Position> getLocationStream({
    int? intervalSeconds,
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) {
    final settings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: 10, // meters
      timeLimit: Duration(
        seconds: intervalSeconds ?? AppConstants.locationUpdateIntervalSeconds,
      ),
    );

    return Geolocator.getPositionStream(locationSettings: settings);
  }
}

/// Geofence validation result
class GeofenceValidation {
  final bool isWithinGeofence;
  final double distance;
  final double currentLatitude;
  final double currentLongitude;
  final double accuracy;

  GeofenceValidation({
    required this.isWithinGeofence,
    required this.distance,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.accuracy,
  });

  String get distanceText {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)}m away';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)}km away';
    }
  }
}

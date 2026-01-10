import 'package:flutter_test/flutter_test.dart';
import 'package:security_officer_app/services/location_service.dart';

void main() {
  group('LocationService', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService();
    });

    group('calculateDistance', () {
      test('should return 0 for same coordinates', () {
        final distance = locationService.calculateDistance(
          51.5074,
          -0.1278,
          51.5074,
          -0.1278,
        );

        expect(distance, equals(0.0));
      });

      test('should calculate distance between two points correctly', () {
        // Distance from London to Paris is approximately 344 km
        final distance = locationService.calculateDistance(
          51.5074, // London
          -0.1278,
          48.8566, // Paris
          2.3522,
        );

        // Allow some margin for calculation differences
        expect(distance, greaterThan(340000)); // > 340 km
        expect(distance, lessThan(350000)); // < 350 km
      });

      test('should handle negative coordinates', () {
        final distance = locationService.calculateDistance(
          -33.8688, // Sydney
          151.2093,
          40.7128, // New York
          -74.0060,
        );

        // Distance should be approximately 16,000 km
        expect(distance, greaterThan(15000000));
        expect(distance, lessThan(17000000));
      });
    });

    group('GeofenceValidation', () {
      test('should be within geofence when distance is less than threshold', () {
        final validation = GeofenceValidation(
          isWithinGeofence: true,
          distance: 50.0,
          currentLatitude: 51.5074,
          currentLongitude: -0.1278,
          accuracy: 10.0,
        );

        expect(validation.isWithinGeofence, isTrue);
        expect(validation.distance, equals(50.0));
        expect(validation.currentLatitude, equals(51.5074));
        expect(validation.currentLongitude, equals(-0.1278));
        expect(validation.accuracy, equals(10.0));
      });

      test('should be outside geofence when distance exceeds threshold', () {
        final validation = GeofenceValidation(
          isWithinGeofence: false,
          distance: 150.0,
          currentLatitude: 51.5074,
          currentLongitude: -0.1278,
          accuracy: 10.0,
        );

        expect(validation.isWithinGeofence, isFalse);
        expect(validation.distance, equals(150.0));
      });

      test('distanceText should format distance in meters', () {
        final validation = GeofenceValidation(
          isWithinGeofence: false,
          distance: 500.0,
          currentLatitude: 51.5074,
          currentLongitude: -0.1278,
          accuracy: 10.0,
        );

        expect(validation.distanceText, equals('500m away'));
      });

      test('distanceText should format distance in kilometers', () {
        final validation = GeofenceValidation(
          isWithinGeofence: false,
          distance: 2500.0,
          currentLatitude: 51.5074,
          currentLongitude: -0.1278,
          accuracy: 10.0,
        );

        expect(validation.distanceText, equals('2.5km away'));
      });
    });
  });
}

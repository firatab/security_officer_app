import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/api_endpoints.dart';
import '../core/errors/exceptions.dart';
import '../core/network/dio_client.dart';
import '../core/utils/logger.dart';
import '../data/models/user_model.dart';
import '../data/database/app_database.dart';
import 'background_notification_service.dart';

class AuthService {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AppDatabase _database;

  AuthService(this._dioClient, this._database);

  /// Login with email, password, and organization slug
  Future<LoginResponse> login(String email, String password, {String? organizationSlug}) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
          if (organizationSlug != null && organizationSlug.isNotEmpty)
            'tenantSlug': organizationSlug,
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // Store tokens and user info (including organization slug)
        await _saveAuthData(loginResponse, organizationSlug: organizationSlug);

        // Start background notification service
        await _startBackgroundNotifications();

        AppLogger.info('Login successful for user: ${loginResponse.user.email}');
        return loginResponse;
      } else {
        throw AuthException('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      AppLogger.error('Login failed', e);
      if (e.response?.statusCode == 401) {
        throw AuthException('Invalid credentials or organization not found');
      } else if (e.response?.statusCode == 403) {
        throw AuthException('Account is disabled or not authorized');
      } else if (e.response?.statusCode == 400) {
        // Parse validation errors from backend
        final errorMessage = e.response?.data?['error'] ?? 'Invalid request';
        throw AuthException(errorMessage);
      } else {
        throw NetworkException('Network error during login: ${e.message}');
      }
    } catch (e) {
      AppLogger.error('Unexpected login error', e);
      throw AuthException('Login failed: $e');
    }
  }

  /// Logout and clear all local data
  Future<void> logout() async {
    try {
      // Stop background notification service
      await _stopBackgroundNotifications();

      // Try to call logout endpoint
      try {
        await _dioClient.dio.post(ApiEndpoints.logout);
      } catch (e) {
        AppLogger.warning('Logout endpoint call failed (continuing anyway)', e);
      }

      // Clear all auth data and local database
      await _clearAuthData();
      await _database.clearAllData();

      AppLogger.info('Logout successful');
    } catch (e) {
      AppLogger.error('Error during logout', e);
      throw AuthException('Logout failed: $e');
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null;
  }

  /// Get current user info from storage
  Future<Map<String, String?>> getCurrentUserInfo() async {
    return {
      'userId': await _storage.read(key: AppConstants.userIdKey),
      'employeeId': await _storage.read(key: AppConstants.employeeIdKey),
      'tenantId': await _storage.read(key: AppConstants.tenantIdKey),
      'shiftId': await _storage.read(key: AppConstants.currentShiftIdKey),
      'siteId': await _storage.read(key: AppConstants.currentSiteIdKey),
    };
  }

  /// Get current shift ID from storage
  Future<String> getCurrentShiftId() async {
    final shiftId = await _storage.read(key: AppConstants.currentShiftIdKey);
    if (shiftId == null) {
      throw AuthException('No current shift ID found');
    }
    return shiftId;
  }

  /// Save current shift and site ID to storage
  Future<void> saveActiveShiftInfo(String shiftId, String siteId) async {
    await _storage.write(key: AppConstants.currentShiftIdKey, value: shiftId);
    await _storage.write(key: AppConstants.currentSiteIdKey, value: siteId);
  }

  /// Save authentication data to secure storage
  Future<void> _saveAuthData(LoginResponse loginResponse, {String? organizationSlug}) async {
    await _storage.write(
      key: AppConstants.accessTokenKey,
      value: loginResponse.accessToken,
    );
    await _storage.write(
      key: AppConstants.refreshTokenKey,
      value: loginResponse.refreshToken,
    );
    await _storage.write(
      key: AppConstants.userIdKey,
      value: loginResponse.user.id,
    );
    if (loginResponse.user.tenantId != null) {
      await _storage.write(
        key: AppConstants.tenantIdKey,
        value: loginResponse.user.tenantId,
      );
    }
    if (loginResponse.user.employee != null) {
      await _storage.write(
        key: AppConstants.employeeIdKey,
        value: loginResponse.user.employee!.id,
      );
    }
    // Save organization slug for auto-fill on next login
    if (organizationSlug != null && organizationSlug.isNotEmpty) {
      await _storage.write(
        key: AppConstants.organizationSlugKey,
        value: organizationSlug,
      );
    }
  }

  /// Get saved organization slug for auto-fill
  Future<String?> getSavedOrganizationSlug() async {
    return await _storage.read(key: AppConstants.organizationSlugKey);
  }

  /// Clear all authentication data
  Future<void> _clearAuthData() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.userIdKey);
    await _storage.delete(key: AppConstants.employeeIdKey);
    await _storage.delete(key: AppConstants.tenantIdKey);
    await _storage.delete(key: AppConstants.currentShiftIdKey);
    await _storage.delete(key: AppConstants.currentSiteIdKey);
    // Note: We keep organizationSlugKey for convenience on next login
  }

  /// Start background notification service after successful login
  Future<void> _startBackgroundNotifications() async {
    try {
      final backgroundService = BackgroundNotificationService();
      await backgroundService.start();
      AppLogger.info('Background notification service started');
    } catch (e) {
      AppLogger.error('Failed to start background notifications', e);
    }
  }

  /// Stop background notification service on logout
  Future<void> _stopBackgroundNotifications() async {
    try {
      final backgroundService = BackgroundNotificationService();
      await backgroundService.stop();
      AppLogger.info('Background notification service stopped');
    } catch (e) {
      AppLogger.error('Failed to stop background notifications', e);
    }
  }
}

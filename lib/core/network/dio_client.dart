import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../constants/api_endpoints.dart';
import '../services/server_config_service.dart';
import '../utils/logger.dart';

/// Provider for DioClient - can be overridden in main.dart with server config
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

/// Dio client with authentication interceptor
class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  ServerConfigService? _serverConfig;

  /// Flag to prevent infinite refresh loop
  bool _isRefreshing = false;

  /// Endpoints that should not trigger token refresh
  static const _noRefreshEndpoints = [
    '/api/auth/refresh',
    '/api/auth/login',
    '/api/tenant/validate-code',
    '/api/tenant/info',
  ];

  DioClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
        onResponse: _onResponse,
      ),
    );

    // Add logging interceptor only in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => AppLogger.debug(obj),
      ));
    }
  }

  Dio get dio => _dio;

  /// Update the base URL dynamically
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
    AppLogger.info('DioClient base URL updated to: $newBaseUrl');
  }

  /// Initialize with server config service
  Future<void> initWithServerConfig() async {
    _serverConfig = await ServerConfigService.getInstance();
    if (_serverConfig != null) {
      updateBaseUrl(_serverConfig!.baseUrl);
    }
  }

  /// Get current base URL
  String get currentBaseUrl => _dio.options.baseUrl;

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token to all requests
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    AppLogger.debug(
      'REQUEST[${options.method}] => PATH: ${options.path}',
    );
    return handler.next(options);
  }

  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.debug(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    return handler.next(response);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    AppLogger.error(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      err,
    );

    // Handle 401 Unauthorized - try to refresh token
    if (err.response?.statusCode == 401) {
      final requestPath = err.requestOptions.path;

      // Don't try to refresh for auth-related endpoints (prevents infinite loop)
      final isNoRefreshEndpoint = _noRefreshEndpoints.any(
        (endpoint) => requestPath.contains(endpoint),
      );

      if (isNoRefreshEndpoint) {
        AppLogger.debug('Skipping token refresh for auth endpoint: $requestPath');
        return handler.next(err);
      }

      // Prevent multiple simultaneous refresh attempts
      if (_isRefreshing) {
        AppLogger.debug('Token refresh already in progress, skipping');
        return handler.next(err);
      }

      try {
        _isRefreshing = true;
        final refreshed = await _refreshToken();

        if (refreshed) {
          // Retry the original request
          final options = err.requestOptions;
          final token = await _storage.read(key: AppConstants.accessTokenKey);
          options.headers['Authorization'] = 'Bearer $token';

          final response = await _dio.fetch(options);
          return handler.resolve(response);
        } else {
          // Refresh failed, clear auth and let error propagate
          await _clearAuth();
        }
      } catch (e) {
        AppLogger.error('Token refresh failed', e);
        // Clear tokens and redirect to login
        await _clearAuth();
      } finally {
        _isRefreshing = false;
      }
    }

    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        // Backend may return { data: { accessToken, refreshToken } } or { accessToken, refreshToken }
        final responseData = response.data as Map<String, dynamic>?;
        final tokenData = responseData?['data'] as Map<String, dynamic>? ?? responseData;

        final newAccessToken = tokenData?['accessToken'] ?? tokenData?['token'];
        final newRefreshToken = tokenData?['refreshToken'];

        if (newAccessToken == null) return false;

        await _storage.write(key: AppConstants.accessTokenKey, value: newAccessToken as String);
        if (newRefreshToken != null) {
          await _storage.write(key: AppConstants.refreshTokenKey, value: newRefreshToken as String);
        }

        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('Error refreshing token', e);
      return false;
    }
  }

  Future<void> _clearAuth() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.userIdKey);
    await _storage.delete(key: AppConstants.employeeIdKey);
    await _storage.delete(key: AppConstants.tenantIdKey);
  }

  // Convenience methods for HTTP requests
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) {
    return _dio.delete(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) {
    return _dio.patch(path, data: data);
  }
}

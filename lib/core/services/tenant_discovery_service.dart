import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

/// Result of a tenant discovery attempt
class TenantDiscoveryResult {
  final bool success;
  final String? serverUrl;
  final String? wsUrl;
  final Map<String, dynamic>? tenantData;
  final String? errorMessage;

  TenantDiscoveryResult({
    required this.success,
    this.serverUrl,
    this.wsUrl,
    this.tenantData,
    this.errorMessage,
  });

  factory TenantDiscoveryResult.success({
    required String serverUrl,
    required String wsUrl,
    required Map<String, dynamic> tenantData,
  }) {
    return TenantDiscoveryResult(
      success: true,
      serverUrl: serverUrl,
      wsUrl: wsUrl,
      tenantData: tenantData,
    );
  }

  factory TenantDiscoveryResult.failure(String error) {
    return TenantDiscoveryResult(
      success: false,
      errorMessage: error,
    );
  }
}

/// Service for discovering and validating tenant configurations
/// Handles the bootstrap problem by trying multiple known server URLs
class TenantDiscoveryService {
  /// List of known bootstrap/discovery server URLs to try
  /// These are servers that host the tenant validation endpoint
  /// Configured in AppConstants.fallbackServers
  static List<String> get bootstrapUrls {
    // Use configured fallback servers, with deduplication
    final urls = <String>{};

    // Add primary server first
    urls.add(AppConstants.baseUrl);

    // Add configured fallback servers
    for (final url in AppConstants.fallbackServers) {
      if (url.isNotEmpty) {
        urls.add(url);
      }
    }

    return urls.toList();
  }

  /// Timeout for each connection attempt
  static const Duration connectionTimeout = Duration(seconds: 10);

  /// Timeout for receiving response
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Discover tenant by code, trying multiple bootstrap servers
  ///
  /// This solves the chicken-and-egg problem where we need a server URL
  /// to validate the tenant code, but we get the server URL from validation.
  static Future<TenantDiscoveryResult> discoverByCode(String code) async {
    final normalizedCode = code.trim();

    if (normalizedCode.isEmpty) {
      return TenantDiscoveryResult.failure('Tenant code cannot be empty');
    }

    final errors = <String>[];

    // Try each bootstrap URL in order
    for (final baseUrl in bootstrapUrls) {
      AppLogger.info('Trying tenant discovery at: $baseUrl');

      try {
        final result = await _tryValidateCode(baseUrl, normalizedCode);
        if (result.success) {
          AppLogger.info('Tenant discovered successfully via: $baseUrl');
          return result;
        }
        errors.add('$baseUrl: ${result.errorMessage}');
      } catch (e) {
        errors.add('$baseUrl: ${e.toString()}');
        AppLogger.debug('Discovery failed at $baseUrl: $e');
      }
    }

    // All servers failed
    AppLogger.error('Tenant discovery failed on all servers');
    return TenantDiscoveryResult.failure(
      'Could not connect to any server. Please check your internet connection.\n\n'
      'Details:\n${errors.join('\n')}',
    );
  }

  /// Discover tenant by direct URL (user provides full server URL)
  static Future<TenantDiscoveryResult> discoverByUrl(String url) async {
    final normalizedUrl = _normalizeUrl(url);

    if (normalizedUrl == null) {
      return TenantDiscoveryResult.failure('Invalid URL format');
    }

    AppLogger.info('Discovering tenant at URL: $normalizedUrl');

    try {
      final result = await _tryGetTenantInfo(normalizedUrl);
      if (result.success) {
        AppLogger.info('Tenant discovered successfully at: $normalizedUrl');
        return result;
      }
      return result;
    } catch (e) {
      AppLogger.error('Tenant discovery by URL failed', e);
      return TenantDiscoveryResult.failure(
        'Could not connect to server: ${e.toString()}',
      );
    }
  }

  /// Parse QR code data and discover tenant
  /// QR codes can contain:
  /// - Just a tenant code: "ACME123"
  /// - Full URL: "https://acme.sentraguard.com"
  /// - JSON config: {"code": "ACME123", "url": "https://..."}
  /// - JSON config with server: {"tenantCode": "ACME123", "serverUrl": "https://..."}
  static Future<TenantDiscoveryResult> discoverByQRCode(String qrData) async {
    final trimmedData = qrData.trim();

    if (trimmedData.isEmpty) {
      return TenantDiscoveryResult.failure('QR code is empty');
    }

    AppLogger.info('Processing QR code data: ${trimmedData.substring(0, trimmedData.length > 50 ? 50 : trimmedData.length)}...');

    // Try to parse as JSON first
    if (trimmedData.startsWith('{')) {
      final jsonData = _parseJson(trimmedData);
      if (jsonData != null) {
        AppLogger.debug('QR code parsed as JSON: $jsonData');

        // Check for URL in JSON (multiple possible keys)
        final url = jsonData['url'] as String? ??
            jsonData['serverUrl'] as String? ??
            jsonData['apiUrl'] as String? ??
            jsonData['baseUrl'] as String?;
        if (url != null && url.isNotEmpty) {
          AppLogger.info('QR code contains URL: $url');
          return await discoverByUrl(url);
        }

        // Check for code in JSON (multiple possible keys)
        final code = jsonData['code'] as String? ??
            jsonData['tenantCode'] as String? ??
            jsonData['organizationCode'] as String? ??
            jsonData['slug'] as String?;
        if (code != null && code.isNotEmpty) {
          AppLogger.info('QR code contains tenant code: $code');
          return await discoverByCode(code);
        }

        return TenantDiscoveryResult.failure(
          'QR code JSON does not contain valid tenant configuration',
        );
      }
    }

    // Check if it's a URL
    if (trimmedData.startsWith('http://') || trimmedData.startsWith('https://')) {
      AppLogger.info('QR code is a URL');
      return await discoverByUrl(trimmedData);
    }

    // Treat as tenant code
    AppLogger.info('QR code treated as tenant code');
    return await discoverByCode(trimmedData);
  }

  /// Test if a server is reachable and has the tenant API
  static Future<bool> testServerConnection(String url) async {
    try {
      final dio = _createDio(url);
      final response = await dio.get('/api/health');
      return response.statusCode == 200;
    } catch (e) {
      // Try tenant info endpoint as fallback
      try {
        final dio = _createDio(url);
        final response = await dio.get('/api/tenant/info');
        return response.statusCode == 200 || response.statusCode == 404;
      } catch (_) {
        return false;
      }
    }
  }

  // Private helper methods

  static Future<TenantDiscoveryResult> _tryValidateCode(
    String baseUrl,
    String code,
  ) async {
    final dio = _createDio(baseUrl);

    try {
      final response = await dio.post(
        '/api/tenant/validate-code',
        data: {'code': code},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TenantDiscoveryResult.success(
          serverUrl: data['apiBaseUrl'] as String? ?? baseUrl,
          wsUrl: data['wsBaseUrl'] as String? ?? _generateWsUrl(baseUrl),
          tenantData: data,
        );
      } else if (response.statusCode == 404) {
        return TenantDiscoveryResult.failure('Invalid tenant code');
      } else if (response.statusCode == 403) {
        return TenantDiscoveryResult.failure(
          'This organization is currently inactive',
        );
      } else {
        return TenantDiscoveryResult.failure(
          'Server error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return TenantDiscoveryResult.failure('Invalid tenant code');
      } else if (e.response?.statusCode == 403) {
        final message = e.response?.data?['error'] as String? ??
            'Organization is inactive';
        return TenantDiscoveryResult.failure(message);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return TenantDiscoveryResult.failure('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        return TenantDiscoveryResult.failure('Cannot connect to server');
      }
      return TenantDiscoveryResult.failure(e.message ?? 'Network error');
    }
  }

  static Future<TenantDiscoveryResult> _tryGetTenantInfo(String baseUrl) async {
    final dio = _createDio(baseUrl);

    try {
      final response = await dio.get('/api/tenant/info');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TenantDiscoveryResult.success(
          serverUrl: data['apiBaseUrl'] as String? ?? baseUrl,
          wsUrl: data['wsBaseUrl'] as String? ?? _generateWsUrl(baseUrl),
          tenantData: data,
        );
      } else if (response.statusCode == 404) {
        return TenantDiscoveryResult.failure(
          'No tenant configured for this server',
        );
      } else {
        return TenantDiscoveryResult.failure(
          'Server error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return TenantDiscoveryResult.failure(
          'No tenant configured for this server',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return TenantDiscoveryResult.failure('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        return TenantDiscoveryResult.failure('Cannot connect to server');
      }
      return TenantDiscoveryResult.failure(e.message ?? 'Network error');
    }
  }

  static Dio _createDio(String baseUrl) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectionTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  static String? _normalizeUrl(String url) {
    var normalized = url.trim().toLowerCase();

    // Add https if no protocol specified
    if (!normalized.startsWith('http://') && !normalized.startsWith('https://')) {
      normalized = 'https://$normalized';
    }

    // Remove trailing slash
    if (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    // Validate URL format
    try {
      final uri = Uri.parse(normalized);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return null;
      }
      return normalized;
    } catch (e) {
      return null;
    }
  }

  static String _generateWsUrl(String httpUrl) {
    if (httpUrl.startsWith('https://')) {
      return httpUrl.replaceFirst('https://', 'wss://');
    } else if (httpUrl.startsWith('http://')) {
      return httpUrl.replaceFirst('http://', 'ws://');
    }
    return httpUrl;
  }

  static Map<String, dynamic>? _parseJson(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

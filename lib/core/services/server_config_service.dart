import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

/// Service to manage server configuration (API URL)
/// Allows changing the server URL at runtime from the login screen
class ServerConfigService {
  static const String _serverUrlKey = 'server_api_url';
  static const String _wsUrlKey = 'server_ws_url';

  static ServerConfigService? _instance;
  static SharedPreferences? _prefs;

  // Current cached URLs
  String _baseUrl = AppConstants.baseUrl;
  String _wsUrl = AppConstants.wsUrl;

  ServerConfigService._();

  /// Get singleton instance
  static Future<ServerConfigService> getInstance() async {
    if (_instance == null) {
      _instance = ServerConfigService._();
      _prefs = await SharedPreferences.getInstance();
      await _instance!._loadConfig();
    }
    return _instance!;
  }

  /// Initialize the service (call at app startup)
  static Future<void> initialize() async {
    await getInstance();
  }

  /// Load saved configuration
  Future<void> _loadConfig() async {
    _baseUrl = _prefs?.getString(_serverUrlKey) ?? AppConstants.baseUrl;
    _wsUrl = _prefs?.getString(_wsUrlKey) ?? AppConstants.wsUrl;
    AppLogger.info('Server config loaded - API: $_baseUrl, WS: $_wsUrl');
  }

  /// Get current API base URL
  String get baseUrl => _baseUrl;

  /// Get current WebSocket URL
  String get wsUrl => _wsUrl;

  /// Check if using custom server
  bool get isCustomServer => _baseUrl != AppConstants.baseUrl;

  /// Update server URL
  /// Returns true if URL was changed and saved successfully
  Future<bool> setServerUrl(String apiUrl, {String? wsUrl}) async {
    try {
      // Validate URL format
      if (!_isValidUrl(apiUrl)) {
        AppLogger.error('Invalid API URL format: $apiUrl');
        return false;
      }

      // Save API URL
      await _prefs?.setString(_serverUrlKey, apiUrl);
      _baseUrl = apiUrl;

      // Generate or save WebSocket URL
      if (wsUrl != null && _isValidUrl(wsUrl)) {
        await _prefs?.setString(_wsUrlKey, wsUrl);
        _wsUrl = wsUrl;
      } else {
        // Auto-generate WS URL from API URL
        final generatedWsUrl = _generateWsUrl(apiUrl);
        await _prefs?.setString(_wsUrlKey, generatedWsUrl);
        _wsUrl = generatedWsUrl;
      }

      AppLogger.info('Server URL updated - API: $_baseUrl, WS: $_wsUrl');
      return true;
    } catch (e) {
      AppLogger.error('Failed to save server URL', e);
      return false;
    }
  }

  /// Reset to default server URL
  Future<void> resetToDefault() async {
    await _prefs?.remove(_serverUrlKey);
    await _prefs?.remove(_wsUrlKey);
    _baseUrl = AppConstants.baseUrl;
    _wsUrl = AppConstants.wsUrl;
    AppLogger.info('Server URL reset to default');
  }

  /// Validate URL format
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'ws' || uri.scheme == 'wss');
    } catch (e) {
      return false;
    }
  }

  /// Generate WebSocket URL from HTTP URL
  String _generateWsUrl(String httpUrl) {
    String wsUrl = httpUrl;
    if (wsUrl.startsWith('https://')) {
      wsUrl = wsUrl.replaceFirst('https://', 'wss://');
    } else if (wsUrl.startsWith('http://')) {
      wsUrl = wsUrl.replaceFirst('http://', 'ws://');
    }
    return wsUrl;
  }

  /// Test connection to server
  /// Returns null if successful, or error message if failed
  Future<String?> testConnection(String url) async {
    try {
      final uri = Uri.parse(url);
      // Just validate the URL format for now
      // A full connection test would require making an HTTP request
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'Invalid URL format';
      }
      return null;
    } catch (e) {
      return 'Invalid URL: ${e.toString()}';
    }
  }
}

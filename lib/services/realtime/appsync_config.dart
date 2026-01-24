/// AppSync Configuration for Flutter
///
/// This file contains configuration for AWS AppSync GraphQL API.
/// Values are loaded from environment or build-time configuration.

class AppSyncConfig {
  AppSyncConfig._();

  /// Feature flag for realtime provider
  /// Values: 'socket', 'appsync', 'both'
  static const String realtimeProvider =
      String.fromEnvironment('REALTIME_PROVIDER', defaultValue: 'socket');

  /// Check if AppSync is enabled
  static bool get isAppSyncEnabled =>
      realtimeProvider == 'appsync' || realtimeProvider == 'both';

  /// Check if Socket.io is enabled
  static bool get isSocketEnabled =>
      realtimeProvider == 'socket' || realtimeProvider == 'both';

  /// AppSync GraphQL Endpoint
  /// Set via --dart-define=APPSYNC_GRAPHQL_ENDPOINT=...
  static const String graphqlEndpoint = String.fromEnvironment(
    'APPSYNC_GRAPHQL_ENDPOINT',
    defaultValue: '',
  );

  /// AppSync Real-Time Endpoint (WebSocket)
  /// Usually derived from graphqlEndpoint by replacing https:// with wss://
  static String get realtimeEndpoint {
    if (graphqlEndpoint.isEmpty) return '';
    return graphqlEndpoint
        .replaceFirst('https://', 'wss://')
        .replaceFirst('/graphql', '/graphql/realtime');
  }

  /// AWS Region
  static const String region = String.fromEnvironment(
    'AWS_REGION',
    defaultValue: 'eu-west-2',
  );

  /// API Key (for development/testing)
  static const String apiKey = String.fromEnvironment(
    'APPSYNC_API_KEY',
    defaultValue: '',
  );

  /// Whether to use API Key auth (for development)
  static bool get useApiKeyAuth => apiKey.isNotEmpty;

  /// Connection timeout in seconds
  static const int connectionTimeout = 30;

  /// Reconnection delay in milliseconds
  static const int reconnectDelay = 5000;

  /// Maximum reconnection attempts
  static const int maxReconnectAttempts = 10;

  /// Subscription keep-alive interval in seconds
  static const int keepAliveInterval = 30;

  /// Event deduplication cache TTL in milliseconds
  static const int eventCacheTtl = 60000;

  /// Validate configuration
  static bool get isConfigured => graphqlEndpoint.isNotEmpty;

  /// Get configuration summary for logging
  static Map<String, dynamic> toMap() {
    return {
      'realtimeProvider': realtimeProvider,
      'isAppSyncEnabled': isAppSyncEnabled,
      'isSocketEnabled': isSocketEnabled,
      'graphqlEndpoint': graphqlEndpoint.isNotEmpty ? '***configured***' : 'not set',
      'region': region,
      'useApiKeyAuth': useApiKeyAuth,
      'isConfigured': isConfigured,
    };
  }
}

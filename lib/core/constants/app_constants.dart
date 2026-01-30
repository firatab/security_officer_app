/// Application-wide constants
class AppConstants {
  // ============================================
  // API CONFIGURATION
  // ============================================
  //
  // IMPORTANT: These URLs are used as bootstrap/discovery servers.
  // The TenantDiscoveryService will try these URLs to validate tenant codes.
  // Once a tenant is validated, the app uses the tenant-specific URL.
  //
  // For Android Emulator: use 10.0.2.2 (maps to host localhost)
  // For Real Device: use your computer's IP address (e.g., 192.168.1.x)
  // For Production: use your actual server URL

  // ============================================
  // ENVIRONMENT CONFIGURATION
  // ============================================
  // Uncomment ONE of the following configurations:

  // --- LOCAL DEVELOPMENT (Android Emulator) ---
  // static const String baseUrl = 'http://10.0.2.2:3000';
  // static const String wsUrl = 'ws://10.0.2.2:3000';
  // static const bool enableWebSocket = true;

  // --- LOCAL DEVELOPMENT (iOS Simulator/Real Device) ---
  // static const String baseUrl = 'http://192.168.1.X:3000';  // Replace X with your IP
  // static const String wsUrl = 'ws://192.168.1.X:3000';       // Replace X with your IP
  // static const bool enableWebSocket = true;

  // --- PRODUCTION (Live Server) ---
  static const String baseUrl = 'http://3.9.151.4:3001';
  static const String wsUrl = 'ws://3.9.151.4:3001';
  static const bool enableWebSocket = true;

  // --- PRODUCTION (AWS ECS - Full WebSocket Support) ---
  // After deploying to ECS, update these URLs with your ALB DNS or custom domain:
  // static const String baseUrl = 'https://api.yourdomain.com';
  // static const String wsUrl = 'wss://api.yourdomain.com';
  // static const bool enableWebSocket = true;

  // ============================================
  // FALLBACK/BOOTSTRAP SERVERS
  // ============================================
  // These URLs are tried in order when validating tenant codes.
  // Add your backup/failover servers here.
  static const List<String> fallbackServers = [
    baseUrl, // Primary server (from above)
    'https://api.sentraguard.com', // Production API
    'https://app.sentraguard.com', // Alternative production
  ];

  static const String apiVersion = 'v1';

  // Polling Configuration (fallback when WebSocket is disabled)
  static const int pollingIntervalSeconds =
      30; // Poll for updates every 30 seconds

  // Location Settings
  static const int locationUpdateIntervalSeconds = 5;
  static const double geofenceRadiusMeters = 100.0;

  // Check Call Settings
  static const int checkCallNotificationId = 1001;
  static const String checkCallChannelId = 'check_calls';
  static const String checkCallChannelName = 'Check Calls';

  // Sync Settings
  static const int syncRetryAttempts = 3;
  static const int syncRetryDelaySeconds = 5;
  static const int maxOfflineQueueSize = 1000;

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String employeeIdKey = 'employee_id';
  static const String tenantIdKey = 'tenant_id';
  static const String organizationSlugKey = 'organization_slug';
  static const String currentShiftIdKey = 'current_shift_id';
  static const String currentSiteIdKey = 'current_site_id';
  static const String lastSyncKey = 'last_sync_timestamp';

  // Notification Channels
  static const String locationChannelId = 'location_tracking';
  static const String locationChannelName = 'Location Tracking';
  static const String attendanceChannelId = 'attendance';
  static const String attendanceChannelName = 'Attendance Notifications';

  // Background Task IDs
  static const String locationTrackingTaskId = 'location_tracking_task';
  static const String syncQueueTaskId = 'sync_queue_task';

  // App Info
  static const String appName = 'SentraGuard';
  static const String appVersion = '1.0.0';

  // UI Strings
  static const String statusInitializing = 'Initializing...';
  static const String statusCheckingPermissions = 'Checking permissions...';
  static const String statusCheckingAuth = 'Checking authentication...';
  static const String statusLoading = 'Loading...';
  static const String versionLabel = 'Version';
}

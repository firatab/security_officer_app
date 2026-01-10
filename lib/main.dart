import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:security_officer_app/presentation/screens/home/home_screen.dart';
import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/services/server_config_service.dart';
import 'core/utils/logger.dart';
import 'data/database/app_database.dart';
import 'data/repositories/attendance_repository.dart';
import 'data/repositories/check_call_repository.dart';
import 'data/repositories/emergency_repository.dart';
import 'data/repositories/incident_report_repository.dart';
import 'data/repositories/patrol_repository.dart';
import 'data/repositories/patrol_tour_repository.dart';
import 'data/repositories/shift_repository.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/permissions/permissions_screen.dart';
import 'services/auth_service.dart';
import 'services/background_location_service.dart';
import 'services/background_notification_service.dart';
import 'services/check_call_service.dart';
import 'services/location_service.dart';
import 'services/location_tracking_controller.dart';
import 'services/notification_service.dart';
import 'services/offline_manager.dart';
import 'services/permission_service.dart';
import 'services/polling_service.dart';
import 'services/push_notification_service.dart';
import 'services/realtime_data_manager.dart';
import 'services/sync_service.dart';
import 'services/timezone_service.dart';
import 'services/websocket_event_handler.dart';
import 'services/websocket_service.dart';

// Core Providers
final serverConfigProvider = Provider<ServerConfigService>((ref) => throw UnimplementedError());
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final dioClientProvider = Provider<DioClient>(
  (ref) => DioClient(baseUrl: ref.watch(serverConfigProvider).baseUrl),
);

// Repository Providers
final shiftRepositoryProvider = Provider<ShiftRepository>(
  (ref) => ShiftRepository(ref.watch(dioClientProvider), ref.watch(databaseProvider)),
);
final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => AttendanceRepository(ref.watch(dioClientProvider), ref.watch(databaseProvider)),
);
final checkCallRepositoryProvider = Provider<CheckCallRepository>(
  (ref) => CheckCallRepository(ref.watch(dioClientProvider), ref.watch(databaseProvider)),
);
final incidentReportRepositoryProvider = Provider<IncidentReportRepository>(
  (ref) => IncidentReportRepository(ref.watch(dioClientProvider), ref.watch(databaseProvider)),
);
final emergencyRepositoryProvider = Provider<EmergencyRepository>(
  (ref) => EmergencyRepository(ref.watch(dioClientProvider)),
);
final patrolRepositoryProvider = Provider<PatrolRepository>(
  (ref) => PatrolRepository(ref.watch(dioClientProvider), ref.watch(databaseProvider)),
);
final patrolTourRepositoryProvider = Provider<PatrolTourRepository>(
  (ref) => PatrolTourRepository(ref.watch(dioClientProvider), ref.watch(databaseProvider)),
);

// Service Providers
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(dioClientProvider), ref.watch(databaseProvider)),
);
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());
final syncServiceProvider = Provider<SyncService>(
  (ref) => SyncService(ref.watch(dioClientProvider), ref.watch(databaseProvider)),
);
final backgroundLocationServiceProvider = Provider<BackgroundLocationService>(
  (ref) => BackgroundLocationService(),
);
final locationTrackingProvider = StateNotifierProvider<LocationTrackingController, LocationTrackingState>(
  (ref) => LocationTrackingController(
    ref.watch(backgroundLocationServiceProvider),
    ref.watch(locationServiceProvider),
  ),
);
final notificationServiceProvider = Provider<NotificationService>((ref) => throw UnimplementedError());

// Timezone Service Provider
final timezoneServiceProvider = ChangeNotifierProvider<TimezoneService>((ref) => throw UnimplementedError());

// Controller Providers
final checkCallControllerProvider = StateNotifierProvider<CheckCallController, CheckCallState>(
  (ref) => CheckCallController(
    ref.watch(checkCallRepositoryProvider),
    ref.watch(locationServiceProvider),
    ref.watch(notificationServiceProvider),
  ),
);

// WebSocket Providers
// webSocketProvider is imported from websocket_service.dart

final webSocketEventHandlerProvider = Provider<WebSocketEventHandler>(
  (ref) => WebSocketEventHandler(
    wsController: ref.watch(webSocketProvider.notifier),
    database: ref.watch(databaseProvider),
    shiftRepository: ref.watch(shiftRepositoryProvider),
    checkCallRepository: ref.watch(checkCallRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
  ),
);

// Realtime Data Manager Provider - handles WebSocket events and updates local state
final realtimeDataManagerProvider = StateNotifierProvider<RealtimeDataManager, RealtimeDataState>(
  (ref) => RealtimeDataManager(
    wsController: ref.watch(webSocketProvider.notifier),
    database: ref.watch(databaseProvider),
    shiftRepository: ref.watch(shiftRepositoryProvider),
    checkCallRepository: ref.watch(checkCallRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
  ),
);

// Polling Service Provider - fallback for when WebSocket is not available (e.g., AWS Amplify)
final pollingServiceProvider = StateNotifierProvider<PollingService, PollingState>(
  (ref) => PollingService(
    dioClient: ref.watch(dioClientProvider),
    shiftRepository: ref.watch(shiftRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
  ),
);

// Offline Manager Provider
final offlineManagerProvider = StateNotifierProvider<OfflineManager, OfflineState>(
  (ref) => OfflineManager(ref.watch(syncServiceProvider), ref.watch(databaseProvider)),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final serverConfig = await ServerConfigService.getInstance();
  final notificationService = NotificationService();
  await notificationService.initialize();

  final backgroundNotificationService = BackgroundNotificationService();
  await backgroundNotificationService.initialize();

  // Initialize timezone service
  final timezoneService = TimezoneService();
  await timezoneService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        serverConfigProvider.overrideWithValue(serverConfig),
        notificationServiceProvider.overrideWithValue(notificationService),
        timezoneServiceProvider.overrideWithValue(timezoneService),
      ],
      child: const SecurityOfficerApp(),
    ),
  );
}

class SecurityOfficerApp extends StatelessWidget {
  const SecurityOfficerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E40AF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final PermissionService _permissionService = PermissionService();
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _startupSequence();
  }

  Future<void> _startupSequence() async {
    // Brief delay for splash display
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    // Step 1: Check permissions
    setState(() => _statusMessage = 'Checking permissions...');
    final permissionStatus = await _permissionService.checkAllPermissions();

    if (!mounted) return;

    // If required permissions not granted, show permissions screen
    if (!permissionStatus.allRequiredGranted) {
      AppLogger.info('Required permissions not granted, showing permissions screen');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PermissionsScreen(
            onAllPermissionsGranted: () {
              // When permissions granted, restart the flow
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SplashScreen()),
              );
            },
          ),
        ),
      );
      return;
    }

    AppLogger.info('All required permissions granted');

    // Step 2: Check authentication
    setState(() => _statusMessage = 'Checking authentication...');
    final isAuthenticated = await ref.read(authServiceProvider).isAuthenticated();

    if (!mounted) return;

    if (isAuthenticated) {
      // Step 3: Initialize services
      setState(() => _statusMessage = 'Loading...');

      // Initialize push notifications (WebSocket-based, no Firebase)
      try {
        final pushService = ref.read(pushNotificationServiceProvider);
        await pushService.initialize();
        await pushService.registerToken();
      } catch (e) {
        AppLogger.error('Failed to initialize push notifications', e);
      }

      // Navigate to home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Navigate to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              AppConstants.appName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version ${AppConstants.appVersion}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(
              _statusMessage,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

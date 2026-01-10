import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';
import '../../../main.dart';
import '../../../services/push_notification_service.dart';
import '../../../services/websocket_service.dart';
import '../../widgets/connection_status_indicator.dart';
import '../../widgets/offline_status_banner.dart';
import '../../widgets/panic_button.dart';
import '../../widgets/tracking_status_card.dart';
import '../auth/login_screen.dart';
import '../incident/incident_report_screen.dart';
import '../map/map_screen.dart';
import '../patrol/patrol_list_screen.dart';
import '../shifts/shifts_screen.dart';

final userInfoProvider = FutureProvider.autoDispose<Map<String, String?>>((ref) {
  return ref.watch(authServiceProvider).getCurrentUserInfo();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _webSocketInitialized = false;
  bool _realtimeCallbacksSet = false;

  @override
  void initState() {
    super.initState();
    // Connect WebSocket once in initState, not in build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectWebSocket();
      _setupRealtimeCallbacks();
    });
  }

  void _connectWebSocket() {
    if (_webSocketInitialized) return;
    _webSocketInitialized = true;

    try {
      if (AppConstants.enableWebSocket) {
        // Use WebSocket for real-time updates
        ref.read(webSocketProvider.notifier).connect();
        ref.read(webSocketEventHandlerProvider).startListening();
        AppLogger.info('WebSocket connected on home screen init');
      } else {
        // Use HTTP polling as fallback (for AWS Amplify)
        _startPolling();
        AppLogger.info('Using HTTP polling for updates (WebSocket disabled)');
      }
    } catch (e) {
      AppLogger.error('Failed to initialize real-time updates', e);
    }
  }

  void _startPolling() {
    final pollingService = ref.read(pollingServiceProvider.notifier);

    // Set up callbacks for polling updates
    pollingService.onShiftsUpdated = () {
      AppLogger.info('Polling: Shifts updated, refreshing UI');
      ref.invalidate(userInfoProvider);
      if (mounted) setState(() {});
    };

    pollingService.onAttendanceUpdated = () {
      AppLogger.info('Polling: Attendance updated, refreshing UI');
      ref.invalidate(userInfoProvider);
      if (mounted) setState(() {});
    };

    pollingService.onCheckCallAlert = () {
      AppLogger.info('Polling: Check call alert');
      if (mounted) setState(() {});
    };

    pollingService.onNotification = (title, body) {
      AppLogger.info('Polling: Notification - $title');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title: $body'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    };

    // Start polling
    pollingService.startPolling();
  }

  void _setupRealtimeCallbacks() {
    if (_realtimeCallbacksSet) return;
    _realtimeCallbacksSet = true;

    try {
      final realtimeManager = ref.read(realtimeDataManagerProvider.notifier);

      // Set up callbacks for real-time updates
      realtimeManager.onShiftsUpdated = () {
        AppLogger.info('Real-time: Shifts updated, refreshing UI');
        // Invalidate user info to refresh the screen
        ref.invalidate(userInfoProvider);
        if (mounted) setState(() {});
      };

      realtimeManager.onAttendanceUpdated = () {
        AppLogger.info('Real-time: Attendance updated, refreshing UI');
        ref.invalidate(userInfoProvider);
        if (mounted) setState(() {});
      };

      realtimeManager.onCheckCallUpdated = () {
        AppLogger.info('Real-time: Check call updated');
        if (mounted) setState(() {});
      };

      realtimeManager.onPanicAlert = (data) {
        AppLogger.info('Real-time: PANIC ALERT received!');
        if (mounted) {
          _showPanicAlertDialog(data);
        }
      };

      realtimeManager.onNotification = (title, body) {
        AppLogger.info('Real-time: Notification received - $title');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title: $body'),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(label: 'OK', onPressed: () {}),
            ),
          );
        }
      };

      AppLogger.info('Real-time callbacks set up');
    } catch (e) {
      AppLogger.error('Failed to set up real-time callbacks', e);
    }
  }

  void _showPanicAlertDialog(Map<String, dynamic> data) {
    final siteName = data['site']?['name'] as String? ?? 'Unknown Site';
    final reporterName = data['reporterName'] as String? ?? 'Unknown';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.shade50,
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red.shade700, size: 32),
            const SizedBox(width: 8),
            Text('PANIC ALERT', style: TextStyle(color: Colors.red.shade700)),
          ],
        ),
        content: Text(
          '$reporterName triggered a panic alert at $siteName.\n\nPlease respond immediately!',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ACKNOWLEDGE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userInfo = ref.watch(userInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: ConnectionStatusIndicator(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineStatusBanner(),
          Expanded(
            child: userInfo.when(
              data: (user) => _buildContent(user, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error loading user data: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, String?> userInfo, ThemeData theme) {
    final employeeId = userInfo['employeeId'];
    final tenantId = userInfo['tenantId'];
    final shiftId = userInfo['shiftId'];
    final siteId = userInfo['siteId'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanicButton(onPressed: () => _handlePanic(shiftId, siteId), isSending: false),
          const SizedBox(height: 16),
          TrackingStatusCard(employeeId: employeeId, tenantId: tenantId),
          const SizedBox(height: 16),
          _buildQuickActions(context, theme, shiftId, siteId),
          const SizedBox(height: 16),
          _buildFeaturesList(context, theme),
        ],
      ),
    );
  }

  Card _buildQuickActions(BuildContext context, ThemeData theme, String? shiftId, String? siteId) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Actions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _quickActionButton(
              context,
              icon: Icons.schedule,
              label: 'View My Shifts',
              color: theme.colorScheme.primary,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShiftsScreen())),
            ),
            const SizedBox(height: 12),
            _quickActionButton(
              context,
              icon: Icons.report_problem,
              label: 'Create Incident Report',
              color: Colors.orange,
              onPressed: shiftId != null
                  ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => IncidentReportScreen(shiftId: shiftId)))
                  : null, // Disable if no active shift
            ),
            const SizedBox(height: 12),
            _quickActionButton(
              context,
              icon: Icons.tour,
              label: 'Start Patrol',
              color: Colors.blue.shade800,
              onPressed: siteId != null
                  ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => PatrolListScreen(siteId: siteId)))
                  : null, // Disable if no active site
            ),
            const SizedBox(height: 12),
            _quickActionButton(
              context,
              icon: Icons.map,
              label: 'View Site Map',
              color: Colors.green,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActionButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback? onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        minimumSize: const Size(double.infinity, 50),
        disabledBackgroundColor: Colors.grey,
      ),
    );
  }

  Card _buildFeaturesList(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Features', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildFeatureItem(context, Icons.tour, 'Guard Tours', 'Complete patrol routes by scanning QR codes'),
            _buildFeatureItem(context, Icons.warning_amber_rounded, 'Panic Button', 'Send an emergency alert to your supervisor'),
            _buildFeatureItem(context, Icons.report_problem, 'Incident Reporting', 'Create detailed incident reports with photos'),
            _buildFeatureItem(context, Icons.schedule, 'View Shifts', 'See your upcoming shifts and schedules'),
            _buildFeatureItem(context, Icons.location_on, 'Book On/Off', 'Clock in and out of your shifts'),
            _buildFeatureItem(context, Icons.gps_fixed, 'GPS Tracking', 'Location tracked every 15 seconds during shifts'),
            _buildFeatureItem(context, Icons.map, 'Navigate to Sites', 'Get directions to your assigned locations'),
            _buildFeatureItem(context, Icons.phone, 'Check Calls', 'Respond to automated check calls'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(locationTrackingProvider.notifier).stopTracking();
      ref.read(webSocketEventHandlerProvider).stopListening();
      await ref.read(webSocketProvider.notifier).disconnect();

      // Unregister FCM token on logout
      try {
        await ref.read(pushNotificationServiceProvider).unregisterToken();
      } catch (e) {
        AppLogger.error('Failed to unregister FCM token', e);
      }

      await ref.read(authServiceProvider).logout();

      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      AppLogger.error('Logout failed', e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _handlePanic(String? shiftId, String? siteId) async {
    // Check if we have either shiftId or siteId (required by backend)
    if (shiftId == null && siteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be on an active shift to send a panic alert'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Panic Alert', style: TextStyle(color: Colors.red)),
        content: const Text('Are you sure you want to send a panic alert? This will immediately notify your supervisor.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('SEND ALERT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final locationService = ref.read(locationServiceProvider);
      final emergencyRepo = ref.read(emergencyRepositoryProvider);

      final position = await locationService.getCurrentLocation();

      await emergencyRepo.sendPanicAlert(
        latitude: position.latitude,
        longitude: position.longitude,
        shiftId: shiftId,
        siteId: siteId,
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Panic alert sent successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      AppLogger.error('Panic alert failed', e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send panic alert: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

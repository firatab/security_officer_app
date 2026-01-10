import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/utils/logger.dart';
import '../../../services/permission_service.dart';

/// Screen to request and display permission status
class PermissionsScreen extends StatefulWidget {
  final VoidCallback onAllPermissionsGranted;

  const PermissionsScreen({
    super.key,
    required this.onAllPermissionsGranted,
  });

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> with WidgetsBindingObserver {
  final PermissionService _permissionService = PermissionService();
  AppPermissionStatus _permissionStatus = AppPermissionStatus();
  bool _isLoading = true;
  bool _isRequesting = false;
  bool _hasRequestedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAndRequest();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check permissions when app resumes (user may have changed settings)
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  /// Initialize and automatically request permissions
  Future<void> _initializeAndRequest() async {
    setState(() => _isLoading = true);

    // First check current status
    final status = await _permissionService.checkAllPermissions();

    setState(() {
      _permissionStatus = status;
      _isLoading = false;
    });

    // If all required permissions are already granted, proceed
    if (status.allRequiredGranted) {
      widget.onAllPermissionsGranted();
      return;
    }

    // Auto-request permissions after a short delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted && !_hasRequestedOnce) {
      _requestAllPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    setState(() => _isLoading = true);

    final status = await _permissionService.checkAllPermissions();

    setState(() {
      _permissionStatus = status;
      _isLoading = false;
    });

    // If all required permissions are granted, proceed
    if (status.allRequiredGranted) {
      widget.onAllPermissionsGranted();
    }
  }

  Future<void> _requestAllPermissions() async {
    setState(() {
      _isRequesting = true;
      _hasRequestedOnce = true;
    });

    // Check if location services are enabled first
    final locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      // Show dialog to enable location services
      if (mounted) {
        final shouldOpen = await _showLocationServiceDialog();
        if (shouldOpen) {
          await Geolocator.openLocationSettings();
          // Wait for user to return
          setState(() => _isRequesting = false);
          return;
        }
      }
    }

    final status = await _permissionService.requestAllPermissions();

    setState(() {
      _permissionStatus = status;
      _isRequesting = false;
    });

    // Check for permanently denied permissions
    await _checkPermanentlyDenied();

    // If all required permissions are granted, proceed
    if (status.allRequiredGranted) {
      widget.onAllPermissionsGranted();
    }
  }

  Future<void> _checkPermanentlyDenied() async {
    final locationPermanentlyDenied = await Permission.location.isPermanentlyDenied;
    final cameraPermanentlyDenied = await Permission.camera.isPermanentlyDenied;
    final notificationPermanentlyDenied = await Permission.notification.isPermanentlyDenied;

    if (locationPermanentlyDenied || cameraPermanentlyDenied || notificationPermanentlyDenied) {
      if (mounted) {
        _showSettingsDialog();
      }
    }
  }

  Future<bool> _showLocationServiceDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.location_off, color: Colors.orange),
                SizedBox(width: 8),
                Text('Location Services Disabled'),
              ],
            ),
            content: const Text(
              'Location services are required for this app to work properly. '
              'Please enable location services in your device settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Later'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.settings, color: Colors.blue),
            SizedBox(width: 8),
            Text('Permissions Required'),
          ],
        ),
        content: const Text(
          'Some permissions were denied. Please enable them in app settings to use all features.\n\n'
          'Go to Settings > Permissions and enable all required permissions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _permissionService.openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestSinglePermission(Permission permission) async {
    final status = await permission.status;

    if (status.isPermanentlyDenied) {
      // Permission is permanently denied, open settings
      _showSettingsDialog();
      return;
    }

    // Request the permission
    final result = await permission.request();
    AppLogger.info('Permission ${permission.toString()} result: $result');

    // Refresh status
    await _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    Icon(
                      Icons.security,
                      size: 70,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Permissions Required',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please grant all required permissions to continue using the app.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Permission List
                    _buildPermissionTile(
                      icon: Icons.gps_fixed,
                      title: 'Location Services',
                      description: 'Enable GPS on your device',
                      isGranted: _permissionStatus.locationServiceEnabled,
                      isRequired: true,
                      onTap: () async {
                        await Geolocator.openLocationSettings();
                      },
                    ),
                    _buildPermissionTile(
                      icon: Icons.location_on,
                      title: 'Location Permission',
                      description: 'For GPS tracking and attendance',
                      isGranted: _permissionStatus.locationGranted,
                      isRequired: true,
                      onTap: () => _requestSinglePermission(Permission.location),
                    ),
                    _buildPermissionTile(
                      icon: Icons.camera_alt,
                      title: 'Camera',
                      description: 'For incident reports and photos',
                      isGranted: _permissionStatus.cameraGranted,
                      isRequired: true,
                      onTap: () => _requestSinglePermission(Permission.camera),
                    ),
                    _buildPermissionTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      description: 'For check calls and alerts',
                      isGranted: _permissionStatus.notificationGranted,
                      isRequired: true,
                      onTap: () => _requestSinglePermission(Permission.notification),
                    ),
                    _buildPermissionTile(
                      icon: Icons.my_location,
                      title: 'Background Location',
                      description: 'For tracking during shifts',
                      isGranted: _permissionStatus.locationAlwaysGranted,
                      isRequired: false,
                      onTap: () => _requestSinglePermission(Permission.locationAlways),
                    ),

                    const SizedBox(height: 24),

                    // Status indicator
                    if (_permissionStatus.allRequiredGranted)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green[700]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'All required permissions granted!',
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning_amber, color: Colors.orange[700]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Missing Permissions',
                                    style: TextStyle(
                                      color: Colors.orange[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap on each permission above to grant it, or use the button below.',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    if (!_permissionStatus.allRequiredGranted) ...[
                      ElevatedButton.icon(
                        onPressed: _isRequesting ? null : _requestAllPermissions,
                        icon: _isRequesting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check_circle),
                        label: Text(_isRequesting ? 'Requesting...' : 'Grant All Permissions'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _permissionService.openSettings(),
                        icon: const Icon(Icons.settings),
                        label: const Text('Open App Settings'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: widget.onAllPermissionsGranted,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Continue'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _checkPermissions,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Refresh Status'),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required bool isRequired,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isGranted ? 0 : 2,
      color: isGranted ? Colors.green[50] : null,
      child: InkWell(
        onTap: isGranted ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isGranted ? Colors.green[100] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isGranted ? Colors.green[700] : Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isGranted ? Colors.green[900] : null,
                            ),
                          ),
                        ),
                        if (isRequired && !isGranted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Required',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isGranted ? Colors.green[700] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isGranted)
                Icon(Icons.check_circle, color: Colors.green[600], size: 28)
              else
                Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

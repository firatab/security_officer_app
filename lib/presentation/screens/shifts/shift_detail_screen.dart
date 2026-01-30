import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';
import '../../../data/database/app_database.dart';
import '../../../services/location_service.dart';
import '../../../main.dart';
import '../../widgets/check_call_status_card.dart';
import '../../widgets/offline_status_banner.dart';
import '../map/map_screen.dart';

/// Constants for shift time restrictions
class ShiftTimeConfig {
  /// Maximum minutes after shift start time to allow book on
  static const int bookOnGracePeriodMinutes = 30;

  /// Minutes after shift end time to auto book off
  static const int autoBookOffMinutes = 15;
}

// Shift detail provider
final shiftDetailProvider =
    FutureProvider.family<ShiftDetail, String>((ref, shiftId) async {
  final shiftRepo = ref.watch(shiftRepositoryProvider);
  final attendanceRepo = ref.watch(attendanceRepositoryProvider);

  Shift? shift = await shiftRepo.getShiftById(shiftId);
  
  // If not found in local DB, try to sync from API
  if (shift == null) {
    AppLogger.info('Shift $shiftId not found in local DB, attempting API sync');
    try {
      final synchronizedShifts = await shiftRepo.syncShifts();
      shift = await shiftRepo.getShiftById(shiftId);
    } catch (e) {
      AppLogger.error('Failed to sync shift $shiftId from API', e);
    }
  }

  if (shift == null) {
    throw Exception('Shift not found. It may have been deleted or you may be offline.');
  }

  final attendance = await attendanceRepo.getAttendanceForShift(shiftId);

  return ShiftDetail(shift: shift, attendance: attendance);
});

class ShiftDetail {
  final Shift shift;
  final Attendance? attendance;

  ShiftDetail({required this.shift, this.attendance});
}

class ShiftDetailScreen extends ConsumerStatefulWidget {
  final String shiftId;

  const ShiftDetailScreen({super.key, required this.shiftId});

  @override
  ConsumerState<ShiftDetailScreen> createState() => _ShiftDetailScreenState();
}

class _ShiftDetailScreenState extends ConsumerState<ShiftDetailScreen> {
  bool _isBookingOn = false;
  bool _isBookingOff = false;

  @override
  Widget build(BuildContext context) {
    final shiftDetailAsync = ref.watch(shiftDetailProvider(widget.shiftId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Details'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Offline status banner
          const OfflineStatusBanner(),

          // Main content
          Expanded(
            child: shiftDetailAsync.when(
              data: (shiftDetail) => _buildContent(context, shiftDetail),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorView(context, error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ShiftDetail shiftDetail) {
    final shift = shiftDetail.shift;
    final attendance = shiftDetail.attendance;
    final theme = Theme.of(context);
    final now = DateTime.now();

    // Book on time restrictions:
    // - Can book on up to 2 hours before shift starts
    // - Cannot book on if more than 30 minutes after shift start time
    final shiftStartTime = shift.startTime;
    final bookOnDeadline = shiftStartTime.add(const Duration(minutes: 30));
    final canBookOnTime = now.isBefore(bookOnDeadline) &&
                          now.isAfter(shiftStartTime.subtract(const Duration(hours: 2)));
    final canBookOn = attendance == null && canBookOnTime;
    final isLateBookOn = now.isAfter(shiftStartTime) && now.isBefore(bookOnDeadline);
    final bookOnExpired = now.isAfter(bookOnDeadline) && attendance == null;

    // Calculate late minutes for warning
    final lateMinutes = isLateBookOn ? now.difference(shiftStartTime).inMinutes : 0;

    final canBookOff = attendance != null && attendance.bookOffTime == null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Site Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          shift.siteName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.business, 'Client', shift.clientName),
                  _buildInfoRow(Icons.place, 'Address', shift.siteAddress),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Date',
                    DateFormat('EEEE, MMMM d, y').format(shift.shiftDate.toLocal()),
                  ),
                  _buildInfoRow(
                    Icons.access_time,
                    'Time',
                    '${DateFormat('HH:mm').format(shift.startTime.toLocal())} - ${DateFormat('HH:mm').format(shift.endTime.toLocal())}',
                  ),
                  if (shift.breakMinutes > 0)
                    _buildInfoRow(
                      Icons.free_breakfast,
                      'Break',
                      '${shift.breakMinutes} minutes',
                    ),
                  const SizedBox(height: 12),
                  if (shift.siteLatitude != null && shift.siteLongitude != null)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(focusedShift: shift),
                              ),
                            ),
                            icon: const Icon(Icons.map),
                            label: const Text('View on Map'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _openMaps(
                              shift.siteLatitude!,
                              shift.siteLongitude!,
                            ),
                            icon: const Icon(Icons.directions),
                            label: const Text('Navigate'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Check Call Status Card (shown when on duty)
          if (attendance != null && attendance.bookOffTime == null && shift.checkCallEnabled) ...[
            CheckCallStatusCard(siteName: shift.siteName),
            const SizedBox(height: 16),
          ],

          // Attendance Card
          if (attendance != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Attendance',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    if (attendance.bookOnTime != null)
                      _buildAttendanceRow(
                        'Booked On',
                        DateFormat('HH:mm').format(attendance.bookOnTime!),
                        Icons.login,
                        Colors.green,
                      ),
                    if (attendance.bookOffTime != null)
                      _buildAttendanceRow(
                        'Booked Off',
                        DateFormat('HH:mm').format(attendance.bookOffTime!),
                        Icons.logout,
                        Colors.blue,
                      ),
                    if (attendance.totalHours != null)
                      _buildAttendanceRow(
                        'Total Hours',
                        '${attendance.totalHours!.toStringAsFixed(2)} hrs',
                        Icons.schedule,
                        Colors.purple,
                      ),
                    if (attendance.isLate)
                      _buildAttendanceRow(
                        'Late',
                        '${attendance.lateMinutes} minutes',
                        Icons.warning,
                        Colors.orange,
                      ),
                    if (attendance.autoBookedOff)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange[700]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Automatically booked off',
                                  style: TextStyle(color: Colors.orange[900]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Book On Expired Warning
          if (bookOnExpired) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book On Time Expired',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You cannot book on more than 30 minutes after the scheduled start time. Please contact your supervisor.',
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Late Book On Warning
          if (canBookOn && isLateBookOn) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[700], size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You are $lateMinutes minutes late',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your shift started at ${DateFormat('HH:mm').format(shiftStartTime.toLocal())}. You have ${30 - lateMinutes} minutes left to book on.',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Action Buttons
          if (canBookOn)
            ElevatedButton.icon(
              onPressed: _isBookingOn ? null : () => _handleBookOn(isLate: isLateBookOn, lateMinutes: lateMinutes),
              icon: _isBookingOn
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.login),
              label: Text(_isBookingOn ? 'Booking On...' : (isLateBookOn ? 'Book On (Late)' : 'Book On')),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLateBookOn ? Colors.orange : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

          if (canBookOff)
            ElevatedButton.icon(
              onPressed: _isBookingOff ? null : _handleBookOff,
              icon: _isBookingOff
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.logout),
              label: Text(_isBookingOff ? 'Booking Off...' : 'Book Off'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading shift',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(shiftDetailProvider(widget.shiftId));
              },
              child: const Text('Retry'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBookOn({bool isLate = false, int lateMinutes = 0}) async {
    // Show confirmation dialog if late
    if (isLate) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange),
              SizedBox(width: 8),
              Text('Late Book On'),
            ],
          ),
          content: Text(
            'You are $lateMinutes minutes late for this shift. '
            'This will be recorded in your attendance record.\n\n'
            'Do you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Book On Anyway'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    setState(() => _isBookingOn = true);

    try {
      final locationService = ref.read(locationServiceProvider);
      final attendanceRepo = ref.read(attendanceRepositoryProvider);
      final offlineManager = ref.read(offlineManagerProvider.notifier);
      final shiftDetail = ref.read(shiftDetailProvider(widget.shiftId)).value!;
      final shift = shiftDetail.shift;

      // Get current location
      final position = await locationService.getCurrentLocation();

      // Validate geofence if site has coordinates
      if (shift.siteLatitude != null && shift.siteLongitude != null) {
        final validation = await locationService.validateGeofence(
          targetLat: shift.siteLatitude!,
          targetLon: shift.siteLongitude!,
        );

        if (!validation.isWithinGeofence) {
          if (!mounted) return;
          _showGeofenceDialog(validation);
          setState(() => _isBookingOn = false);
          return;
        }
      }

      bool bookedOffline = false;

      // Try online first, fall back to offline
      try {
        await attendanceRepo.bookOnOnline(
          shiftId: widget.shiftId,
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } on NetworkException catch (e) {
        AppLogger.warning('Online book on failed, using offline mode: $e');

        // Fall back to offline booking
        await attendanceRepo.bookOnOffline(
          shiftId: widget.shiftId,
          employeeId: shift.employeeId,
          tenantId: shift.tenantId,
          latitude: position.latitude,
          longitude: position.longitude,
        );
        bookedOffline = true;

        // Trigger sync when connection is restored
        offlineManager.scheduleSync();
      }

      if (!mounted) return;

      // Start location tracking
      await _startLocationTracking(shift.employeeId, shift.tenantId);

      // Start check call monitoring if enabled
      if (shift.checkCallEnabled && shift.checkCallFrequency != null) {
        await _startCheckCallMonitoring(
          shift: shift,
          employeeId: shift.employeeId,
          tenantId: shift.tenantId,
        );
      }

      // Refresh shift detail
      ref.invalidate(shiftDetailProvider(widget.shiftId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookedOffline
            ? 'Booked on offline. Will sync when connected.'
            : 'Successfully booked on! Location tracking started.'),
          backgroundColor: bookedOffline ? Colors.orange : Colors.green,
        ),
      );
    } catch (e) {
      AppLogger.error('Book on failed', e);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book on failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isBookingOn = false);
      }
    }
  }

  Future<void> _handleBookOff() async {
    setState(() => _isBookingOff = true);

    try {
      final locationService = ref.read(locationServiceProvider);
      final attendanceRepo = ref.read(attendanceRepositoryProvider);
      final offlineManager = ref.read(offlineManagerProvider.notifier);

      // Get current location
      final position = await locationService.getCurrentLocation();

      bool bookedOffline = false;

      // Try online first, fall back to offline
      try {
        await attendanceRepo.bookOffApi(
          shiftId: widget.shiftId,
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } on NetworkException catch (e) {
        AppLogger.warning('Online book off failed, using offline mode: $e');

        // Fall back to offline booking
        await attendanceRepo.bookOffOffline(
          shiftId: widget.shiftId,
          latitude: position.latitude,
          longitude: position.longitude,
        );
        bookedOffline = true;

        // Trigger sync when connection is restored
        offlineManager.scheduleSync();
      }

      if (!mounted) return;

      // Stop location tracking
      await _stopLocationTracking();

      // Stop check call monitoring
      await _stopCheckCallMonitoring();

      // Refresh shift detail
      ref.invalidate(shiftDetailProvider(widget.shiftId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookedOffline
            ? 'Booked off offline. Will sync when connected.'
            : 'Successfully booked off! Location tracking stopped.'),
          backgroundColor: bookedOffline ? Colors.orange : Colors.blue,
        ),
      );
    } catch (e) {
      AppLogger.error('Book off failed', e);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book off failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isBookingOff = false);
      }
    }
  }

  void _showGeofenceDialog(GeofenceValidation validation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Check'),
        content: Text(
          'You are ${validation.distanceText} from the site location. '
          'Please move closer to the site to book on.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _openMaps(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps')),
      );
    }
  }

  Future<void> _startLocationTracking(String employeeId, String tenantId) async {
    try {
      final trackingController = ref.read(locationTrackingProvider.notifier);
      await trackingController.startTracking(
        employeeId: employeeId,
        tenantId: tenantId,
        shiftId: widget.shiftId,
      );
      AppLogger.info('Location tracking started for shift ${widget.shiftId}');
    } catch (e) {
      AppLogger.error('Failed to start location tracking', e);
    }
  }

  Future<void> _stopLocationTracking() async {
    try {
      final trackingController = ref.read(locationTrackingProvider.notifier);
      await trackingController.stopTracking();
      AppLogger.info('Location tracking stopped for shift ${widget.shiftId}');
    } catch (e) {
      AppLogger.error('Failed to stop location tracking', e);
    }
  }

  Future<void> _startCheckCallMonitoring({
    required Shift shift,
    required String employeeId,
    required String tenantId,
  }) async {
    try {
      final checkCallRepo = ref.read(checkCallRepositoryProvider);
      final checkCallController = ref.read(checkCallControllerProvider.notifier);

      // Create check calls for the shift if not already created
      final existingCalls = await checkCallRepo.getCheckCallsForShift(shift.id);
      if (existingCalls.isEmpty && shift.checkCallFrequency != null) {
        await checkCallRepo.createCheckCallsForShift(
          shiftId: shift.id,
          employeeId: employeeId,
          tenantId: tenantId,
          startTime: DateTime.now(),
          endTime: shift.endTime,
          frequencyMinutes: shift.checkCallFrequency!,
        );
      }

      // Start monitoring
      await checkCallController.startMonitoring(
        shiftId: shift.id,
        employeeId: employeeId,
        siteName: shift.siteName,
      );

      AppLogger.info('Check call monitoring started for shift ${shift.id}');
    } catch (e) {
      AppLogger.error('Failed to start check call monitoring', e);
    }
  }

  Future<void> _stopCheckCallMonitoring() async {
    try {
      final checkCallController = ref.read(checkCallControllerProvider.notifier);
      await checkCallController.stopMonitoring();
      AppLogger.info('Check call monitoring stopped for shift ${widget.shiftId}');
    } catch (e) {
      AppLogger.error('Failed to stop check call monitoring', e);
    }
  }
}

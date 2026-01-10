import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../services/location_tracking_controller.dart';

class TrackingStatusCard extends ConsumerStatefulWidget {
  final String? employeeId;
  final String? tenantId;

  const TrackingStatusCard({
    super.key,
    this.employeeId,
    this.tenantId,
  });

  @override
  ConsumerState<TrackingStatusCard> createState() => _TrackingStatusCardState();
}

class _TrackingStatusCardState extends ConsumerState<TrackingStatusCard> {
  @override
  void initState() {
    super.initState();
    // Initialize tracking controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationTrackingProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(locationTrackingProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  trackingState.isTracking ? Icons.gps_fixed : Icons.gps_off,
                  color: trackingState.isTracking ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  'Location Tracking',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildStatusBadge(trackingState),
              ],
            ),
            const Divider(height: 24),

            // Tracking info
            if (trackingState.isTracking) ...[
              _buildInfoRow(
                'Status',
                'Active',
                Icons.check_circle,
                Colors.green,
              ),
              if (trackingState.lastUpdate != null)
                _buildInfoRow(
                  'Last Update',
                  DateFormat('HH:mm:ss').format(trackingState.lastUpdate!),
                  Icons.access_time,
                  theme.colorScheme.primary,
                ),
              _buildInfoRow(
                'Points Logged',
                '${trackingState.locationCount}',
                Icons.location_on,
                theme.colorScheme.primary,
              ),
              if (trackingState.lastPosition != null)
                _buildInfoRow(
                  'Accuracy',
                  '${trackingState.lastPosition!.accuracy.toStringAsFixed(1)}m',
                  Icons.my_location,
                  theme.colorScheme.primary,
                ),
            ] else ...[
              _buildInfoRow(
                'Status',
                'Inactive',
                Icons.pause_circle,
                Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                'Tracking starts automatically when you book on to a shift',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],

            // Error message
            if (trackingState.error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trackingState.error!,
                        style: TextStyle(color: Colors.red[900], fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        ref.read(locationTrackingProvider.notifier).clearError();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: trackingState.isTracking
                      ? ElevatedButton.icon(
                          onPressed: () {
                            ref.read(locationTrackingProvider.notifier).stopTracking();
                          },
                          icon: const Icon(Icons.stop),
                          label: const Text('Stop Tracking'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: widget.employeeId != null && widget.tenantId != null
                              ? () {
                                  ref.read(locationTrackingProvider.notifier).startTracking(
                                    employeeId: widget.employeeId!,
                                    tenantId: widget.tenantId!,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start Tracking'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(LocationTrackingState state) {
    final isActive = state.isTracking;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'ON' : 'OFF',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.green[900] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../services/offline_manager.dart';

/// A banner that shows offline status and pending sync operations
class OfflineStatusBanner extends ConsumerWidget {
  const OfflineStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineState = ref.watch(offlineManagerProvider);

    // Don't show if online and no pending operations
    if (offlineState.isOnline && !offlineState.hasUnsynced && !offlineState.isSyncing) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: _getBannerColor(offlineState),
        child: SafeArea(
          bottom: false,
          child: InkWell(
            onTap: () => _showSyncDetails(context, ref, offlineState),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildStatusIcon(offlineState),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getStatusTitle(offlineState),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        if (_getStatusSubtitle(offlineState) != null)
                          Text(
                            _getStatusSubtitle(offlineState)!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (offlineState.isSyncing)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else if (offlineState.isOnline && offlineState.hasUnsynced)
                    TextButton(
                      onPressed: () => ref.read(offlineManagerProvider.notifier).syncNow(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('Sync Now'),
                    )
                  else
                    const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(OfflineState state) {
    if (state.isSyncing) {
      return const Icon(Icons.sync, color: Colors.white, size: 20);
    }
    if (!state.isOnline) {
      return const Icon(Icons.cloud_off, color: Colors.white, size: 20);
    }
    if (state.failedOperations > 0) {
      return const Icon(Icons.error_outline, color: Colors.white, size: 20);
    }
    if (state.pendingOperations > 0) {
      return const Icon(Icons.cloud_upload, color: Colors.white, size: 20);
    }
    return const Icon(Icons.cloud_done, color: Colors.white, size: 20);
  }

  Color _getBannerColor(OfflineState state) {
    if (state.isSyncing) return Colors.blue;
    if (!state.isOnline) return Colors.grey[700]!;
    if (state.failedOperations > 0) return Colors.red;
    if (state.pendingOperations > 0) return Colors.orange;
    return Colors.green;
  }

  String _getStatusTitle(OfflineState state) {
    if (state.isSyncing) return 'Syncing...';
    if (!state.isOnline) return 'Offline Mode';
    if (state.failedOperations > 0) return 'Sync Error';
    if (state.pendingOperations > 0) return 'Pending Sync';
    return 'Synced';
  }

  String? _getStatusSubtitle(OfflineState state) {
    if (state.isSyncing) {
      return '${state.pendingOperations} operations remaining';
    }
    if (!state.isOnline) {
      return '${state.pendingOperations} operations waiting';
    }
    if (state.failedOperations > 0) {
      return '${state.failedOperations} failed operations';
    }
    if (state.pendingOperations > 0) {
      return '${state.pendingOperations} operations to sync';
    }
    return null;
  }

  void _showSyncDetails(BuildContext context, WidgetRef ref, OfflineState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SyncDetailsSheet(state: state),
    );
  }
}

class _SyncDetailsSheet extends ConsumerWidget {
  final OfflineState state;

  const _SyncDetailsSheet({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getStatusDescription(),
                      style: TextStyle(color: _getStatusColor()),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),

          // Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Pending',
                  state.pendingOperations.toString(),
                  Icons.cloud_upload,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Failed',
                  state.failedOperations.toString(),
                  Icons.error_outline,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Last sync time
          if (state.lastSyncTime != null)
            _buildInfoRow(
              Icons.schedule,
              'Last Sync',
              _formatLastSync(state.lastSyncTime!),
            ),

          // Error message
          if (state.lastError != null) ...[
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
                      state.lastError!,
                      style: TextStyle(color: Colors.red[900], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              if (state.failedOperations > 0) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(offlineManagerProvider.notifier).retryFailedOperations();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Failed'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: state.isOnline && !state.isSyncing
                      ? () {
                          ref.read(offlineManagerProvider.notifier).syncNow();
                          Navigator.pop(context);
                        }
                      : null,
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          if (state.failedOperations > 0) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  ref.read(offlineManagerProvider.notifier).clearFailedOperations();
                  Navigator.pop(context);
                },
                child: Text(
                  'Clear Failed Operations',
                  style: TextStyle(color: Colors.red[700]),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  IconData _getStatusIcon() {
    if (state.isSyncing) return Icons.sync;
    if (!state.isOnline) return Icons.cloud_off;
    if (state.failedOperations > 0) return Icons.error_outline;
    if (state.pendingOperations > 0) return Icons.cloud_upload;
    return Icons.cloud_done;
  }

  Color _getStatusColor() {
    if (state.isSyncing) return Colors.blue;
    if (!state.isOnline) return Colors.grey;
    if (state.failedOperations > 0) return Colors.red;
    if (state.pendingOperations > 0) return Colors.orange;
    return Colors.green;
  }

  String _getStatusDescription() {
    if (state.isSyncing) return 'Syncing data...';
    if (!state.isOnline) return 'No network connection';
    if (state.failedOperations > 0) return 'Some operations failed';
    if (state.pendingOperations > 0) return 'Data waiting to sync';
    return 'All data synced';
  }

  String _formatLastSync(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

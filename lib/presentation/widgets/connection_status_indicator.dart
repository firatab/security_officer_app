import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../services/websocket_service.dart';

/// A compact connection status indicator for the app bar
class ConnectionStatusIndicator extends ConsumerWidget {
  const ConnectionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsState = ref.watch(webSocketProvider);

    // When WebSocket is disabled, show "Online" with HTTP polling mode
    final bool isPollingMode = !AppConstants.enableWebSocket;

    return GestureDetector(
      onTap: () => _showConnectionDetails(context, ref, wsState, isPollingMode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPollingMode ? Colors.green : _getBackgroundColor(wsState.connectionState),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isPollingMode
                ? const Icon(Icons.sync, size: 14, color: Colors.white)
                : _buildStatusIcon(wsState.connectionState),
            const SizedBox(width: 4),
            Text(
              isPollingMode ? 'Online' : _getStatusText(wsState.connectionState),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.connected:
        return const Icon(Icons.wifi, size: 14, color: Colors.white);
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        );
      case WebSocketConnectionState.disconnected:
        return const Icon(Icons.wifi_off, size: 14, color: Colors.white);
      case WebSocketConnectionState.error:
        return const Icon(Icons.error_outline, size: 14, color: Colors.white);
    }
  }

  Color _getBackgroundColor(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.connected:
        return Colors.green;
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return Colors.orange;
      case WebSocketConnectionState.disconnected:
        return Colors.grey;
      case WebSocketConnectionState.error:
        return Colors.red;
    }
  }

  String _getStatusText(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.connected:
        return 'Online';
      case WebSocketConnectionState.connecting:
        return 'Connecting';
      case WebSocketConnectionState.reconnecting:
        return 'Reconnecting';
      case WebSocketConnectionState.disconnected:
        return 'Offline';
      case WebSocketConnectionState.error:
        return 'Error';
    }
  }

  void _showConnectionDetails(
    BuildContext context,
    WidgetRef ref,
    WebSocketState wsState,
    bool isPollingMode,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _ConnectionDetailsSheet(
        wsState: wsState,
        isPollingMode: isPollingMode,
      ),
    );
  }
}

class _ConnectionDetailsSheet extends ConsumerWidget {
  final WebSocketState wsState;
  final bool isPollingMode;

  const _ConnectionDetailsSheet({
    required this.wsState,
    required this.isPollingMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Show polling mode info
    if (isPollingMode) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sync, color: Colors.green, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connection Status',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Online (HTTP Polling)',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildInfoRow(
              context,
              'Connection Mode',
              'HTTP Polling',
              Icons.http,
            ),
            _buildInfoRow(
              context,
              'Update Interval',
              '${AppConstants.pollingIntervalSeconds} seconds',
              Icons.timer,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'The app is using HTTP polling for updates. This is normal for cloud deployments.',
                      style: TextStyle(color: Colors.blue[900], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check),
                label: const Text('OK'),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getStatusIcon(wsState.connectionState),
                color: _getStatusColor(wsState.connectionState),
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getStatusDescription(wsState.connectionState),
                      style: TextStyle(
                        color: _getStatusColor(wsState.connectionState),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),

          // Last connected
          if (wsState.lastConnected != null)
            _buildInfoRow(
              context,
              'Last Connected',
              _formatDateTime(wsState.lastConnected!),
              Icons.access_time,
            ),

          // Reconnect attempts
          if (wsState.reconnectAttempts > 0)
            _buildInfoRow(
              context,
              'Reconnect Attempts',
              '${wsState.reconnectAttempts} / ${WebSocketController.maxReconnectAttempts}',
              Icons.refresh,
            ),

          // Error message
          if (wsState.errorMessage != null) ...[
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
                      wsState.errorMessage!,
                      style: TextStyle(color: Colors.red[900], fontSize: 13),
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
              if (!wsState.isConnected)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(webSocketProvider.notifier).connect();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reconnect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              if (wsState.isConnected) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(webSocketProvider.notifier).disconnect();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.power_settings_new),
                    label: const Text('Disconnect'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.connected:
        return Icons.cloud_done;
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return Icons.cloud_sync;
      case WebSocketConnectionState.disconnected:
        return Icons.cloud_off;
      case WebSocketConnectionState.error:
        return Icons.cloud_off;
    }
  }

  Color _getStatusColor(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.connected:
        return Colors.green;
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return Colors.orange;
      case WebSocketConnectionState.disconnected:
        return Colors.grey;
      case WebSocketConnectionState.error:
        return Colors.red;
    }
  }

  String _getStatusDescription(WebSocketConnectionState state) {
    switch (state) {
      case WebSocketConnectionState.connected:
        return 'Connected to server';
      case WebSocketConnectionState.connecting:
        return 'Establishing connection...';
      case WebSocketConnectionState.reconnecting:
        return 'Reconnecting to server...';
      case WebSocketConnectionState.disconnected:
        return 'Not connected';
      case WebSocketConnectionState.error:
        return 'Connection error';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../data/database/app_database.dart';
import '../../services/check_call_service.dart';
import '../screens/check_call/check_call_screen.dart';

class CheckCallStatusCard extends ConsumerWidget {
  final String siteName;

  const CheckCallStatusCard({
    super.key,
    required this.siteName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkCallState = ref.watch(checkCallControllerProvider);
    final theme = Theme.of(context);

    if (!checkCallState.isActive) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.phone_callback, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Check Calls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildStatusChip(checkCallState),
              ],
            ),
            const Divider(height: 24),

            // Active check call alert
            if (checkCallState.currentCheckCall != null)
              _buildActiveCheckCallAlert(
                context,
                ref,
                checkCallState.currentCheckCall!,
              ),

            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Answered',
                  checkCallState.answeredCount.toString(),
                  Colors.green,
                  Icons.check_circle,
                ),
                _buildStatItem(
                  context,
                  'Missed',
                  checkCallState.missedCount.toString(),
                  Colors.red,
                  Icons.cancel,
                ),
                _buildStatItem(
                  context,
                  'Pending',
                  checkCallState.pendingCount.toString(),
                  Colors.orange,
                  Icons.schedule,
                ),
              ],
            ),

            // Next check call
            if (checkCallState.nextCheckCall != null) ...[
              const Divider(height: 24),
              _buildNextCheckCallInfo(context, checkCallState.nextCheckCall!),
            ],

            // Error message
            if (checkCallState.error != null) ...[
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
                        checkCallState.error!,
                        style: TextStyle(color: Colors.red[900], fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        ref.read(checkCallControllerProvider.notifier).clearError();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(CheckCallState state) {
    final isActive = state.currentCheckCall != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.red[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.red : Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'ACTION NEEDED' : 'OK',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.red[900] : Colors.green[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCheckCallAlert(
    BuildContext context,
    WidgetRef ref,
    CheckCall checkCall,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[700]!, Colors.red[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'CHECK CALL REQUIRED NOW!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Scheduled: ${DateFormat('HH:mm').format(checkCall.scheduledTime)}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openCheckCallScreen(context, ref, checkCall),
              icon: const Icon(Icons.check_circle),
              label: const Text('RESPOND NOW'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red[700],
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
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
    );
  }

  Widget _buildNextCheckCallInfo(BuildContext context, CheckCall nextCall) {
    final now = DateTime.now();
    final timeUntil = nextCall.scheduledTime.difference(now);
    final theme = Theme.of(context);

    String timeText;
    if (timeUntil.inMinutes < 60) {
      timeText = '${timeUntil.inMinutes} minutes';
    } else {
      timeText = '${timeUntil.inHours}h ${timeUntil.inMinutes % 60}m';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Check Call',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'In $timeText (${DateFormat('HH:mm').format(nextCall.scheduledTime)})',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.primary,
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

  void _openCheckCallScreen(
    BuildContext context,
    WidgetRef ref,
    CheckCall checkCall,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckCallScreen(
          checkCall: checkCall,
          siteName: siteName,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}

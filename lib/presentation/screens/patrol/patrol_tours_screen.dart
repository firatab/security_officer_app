import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/patrol_tour_model.dart';
import '../../../main.dart';
import 'patrol_execution_screen.dart';

/// Provider for fetching patrol tours for a site
final patrolToursProvider =
    FutureProvider.autoDispose.family<List<PatrolTourModel>, String>((ref, siteId) async {
  final patrolTourRepo = ref.watch(patrolTourRepositoryProvider);
  return patrolTourRepo.fetchPatrolToursForSite(siteId);
});

/// Provider for active patrol instance
final activePatrolInstanceProvider =
    FutureProvider.autoDispose.family<PatrolInstanceModel?, String>((ref, employeeId) async {
  final patrolTourRepo = ref.watch(patrolTourRepositoryProvider);
  return patrolTourRepo.getActivePatrolInstance(employeeId);
});

class PatrolToursScreen extends ConsumerWidget {
  final String siteId;
  final String employeeId;
  final String tenantId;
  final String? shiftId;

  const PatrolToursScreen({
    super.key,
    required this.siteId,
    required this.employeeId,
    required this.tenantId,
    this.shiftId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toursAsync = ref.watch(patrolToursProvider(siteId));
    final activePatrolAsync = ref.watch(activePatrolInstanceProvider(employeeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patrol Tours'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(patrolToursProvider(siteId));
              ref.invalidate(activePatrolInstanceProvider(employeeId));
            },
          ),
        ],
      ),
      body: activePatrolAsync.when(
        data: (activePatrol) {
          // If there's an active patrol, show continue button
          if (activePatrol != null) {
            return _buildActivePatrolBanner(context, ref, activePatrol);
          }

          return toursAsync.when(
            data: (tours) => _buildToursList(context, ref, tours),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $err'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(patrolToursProvider(siteId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => toursAsync.when(
          data: (tours) => _buildToursList(context, ref, tours),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildActivePatrolBanner(
      BuildContext context, WidgetRef ref, PatrolInstanceModel activePatrol) {
    return Column(
      children: [
        // Active patrol banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.play_circle_filled,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Patrol In Progress',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: activePatrol.totalPoints > 0
                    ? activePatrol.completedPoints / activePatrol.totalPoints
                    : 0,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 4),
              Text(
                '${activePatrol.completedPoints} of ${activePatrol.totalPoints} points completed',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _continuePatrol(context, ref, activePatrol),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continue Patrol'),
                ),
              ),
            ],
          ),
        ),

        // Show tours list below
        Expanded(
          child: ref.watch(patrolToursProvider(siteId)).when(
                data: (tours) => _buildToursList(context, ref, tours, disabled: true),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
        ),
      ],
    );
  }

  Widget _buildToursList(BuildContext context, WidgetRef ref, List<PatrolTourModel> tours,
      {bool disabled = false}) {
    if (tours.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.route_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No patrol tours available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact your supervisor to set up patrol tours',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        return _buildTourCard(context, ref, tour, disabled: disabled);
      },
    );
  }

  Widget _buildTourCard(BuildContext context, WidgetRef ref, PatrolTourModel tour,
      {bool disabled = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: disabled ? null : () => _startPatrol(context, ref, tour),
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: disabled ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.route,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (tour.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              tour.description!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (!disabled)
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      context,
                      Icons.location_on,
                      '${tour.totalPoints} points',
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      context,
                      Icons.schedule,
                      tour.estimatedDuration != null
                          ? '~${tour.estimatedDuration} min'
                          : 'Est. unknown',
                    ),
                    const SizedBox(width: 12),
                    _buildFrequencyBadge(context, tour),
                  ],
                ),
                if (tour.sequenceRequired) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.sort, size: 14, color: Colors.orange[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Sequence required',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildFrequencyBadge(BuildContext context, PatrolTourModel tour) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (tour.frequencyType) {
      case 'per_shift':
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        icon = Icons.today;
        break;
      case 'fixed_interval':
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        icon = Icons.timer;
        break;
      case 'specific_times':
        backgroundColor = Colors.purple[50]!;
        textColor = Colors.purple[700]!;
        icon = Icons.access_time;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            _getFrequencyLabel(tour.frequencyType),
            style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getFrequencyLabel(String frequencyType) {
    switch (frequencyType) {
      case 'per_shift':
        return 'Per Shift';
      case 'fixed_interval':
        return 'Interval';
      case 'specific_times':
        return 'Scheduled';
      default:
        return 'Unknown';
    }
  }

  void _startPatrol(BuildContext context, WidgetRef ref, PatrolTourModel tour) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Patrol'),
        content: Text('Start patrol "${tour.name}"?\n\n'
            'This patrol has ${tour.totalPoints} checkpoints to visit.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final patrolTourRepo = ref.read(patrolTourRepositoryProvider);

      // Start the patrol instance
      final instance = await patrolTourRepo.startPatrolInstance(
        patrolTourId: tour.id,
        employeeId: employeeId,
        tenantId: tenantId,
        shiftId: shiftId,
      );

      // Get tour details for execution
      final tourDetails = await patrolTourRepo.fetchPatrolTourDetails(tour.id);

      if (context.mounted) {
        Navigator.pop(context); // Close loading

        // Navigate to execution screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatrolExecutionScreen(
              instance: instance,
              tour: tourDetails ?? tour,
              employeeId: employeeId,
              tenantId: tenantId,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start patrol: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _continuePatrol(
      BuildContext context, WidgetRef ref, PatrolInstanceModel activePatrol) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final patrolTourRepo = ref.read(patrolTourRepositoryProvider);

      // Get instance with completions
      final instanceDetails =
          await patrolTourRepo.getPatrolInstanceDetails(activePatrol.id);

      // Get tour details
      final tour = await patrolTourRepo.fetchPatrolTourDetails(activePatrol.patrolTourId);

      if (context.mounted) {
        Navigator.pop(context); // Close loading

        if (instanceDetails != null && tour != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatrolExecutionScreen(
                instance: instanceDetails,
                tour: tour,
                employeeId: employeeId,
                tenantId: tenantId,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load patrol details'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load patrol: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

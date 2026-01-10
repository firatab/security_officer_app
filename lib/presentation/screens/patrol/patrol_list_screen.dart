import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/patrol.dart';
import '../../../main.dart';
import 'patrol_detail_screen.dart';

final patrolsProvider = FutureProvider.autoDispose.family<List<Patrol>, String>((ref, siteId) async {
  final patrolRepo = ref.watch(patrolRepositoryProvider);
  return patrolRepo.fetchPatrolsForSite(siteId);
});

class PatrolListScreen extends ConsumerWidget {
  final String siteId;
  const PatrolListScreen({super.key, required this.siteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patrolsAsync = ref.watch(patrolsProvider(siteId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Patrol'),
      ),
      body: patrolsAsync.when(
        data: (patrols) {
          if (patrols.isEmpty) {
            return const Center(child: Text('No patrols found for this site.'));
          }
          return ListView.builder(
            itemCount: patrols.length,
            itemBuilder: (context, index) {
              final patrol = patrols[index];
              return ListTile(
                title: Text(patrol.name),
                subtitle: Text(patrol.description ?? ''),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatrolDetailScreen(patrol: patrol),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

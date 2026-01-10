import 'package:flutter/material.dart';

import '../../../data/models/patrol.dart';
import 'qr_scanner_screen.dart';

class PatrolDetailScreen extends StatelessWidget {
  final Patrol patrol;
  const PatrolDetailScreen({super.key, required this.patrol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patrol.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(patrol.description ?? '', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            Text('Checkpoints', style: Theme.of(context).textTheme.titleLarge),
            Expanded(
              child: ListView.builder(
                itemCount: patrol.checkpoints.length,
                itemBuilder: (context, index) {
                  final checkpoint = patrol.checkpoints[index];
                  return ListTile(
                    leading: Icon(
                      checkpoint.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: checkpoint.completed ? Colors.green : Colors.grey,
                    ),
                    title: Text(checkpoint.name),
                    subtitle: Text(checkpoint.instructions ?? ''),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Start Patrol'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRScannerScreen(patrol: patrol),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

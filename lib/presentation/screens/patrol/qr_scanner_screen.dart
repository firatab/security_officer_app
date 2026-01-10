import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:security_officer_app/main.dart';

import '../../../data/models/patrol.dart';

final qrScannerViewModelProvider = StateNotifierProvider.autoDispose.family<
    QRScannerViewModel, QRScannerState, Patrol>(
  (ref, patrol) => QRScannerViewModel(ref, patrol),
);

class QRScannerScreen extends ConsumerWidget {
  final Patrol patrol;

  const QRScannerScreen({super.key, required this.patrol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(qrScannerViewModelProvider(patrol).notifier);
    final state = ref.watch(qrScannerViewModelProvider(patrol));

    ref.listen<QRScannerState>(qrScannerViewModelProvider(patrol), (previous, next) {
      if (next.scanResult != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${next.scanResult} completed!')),
        );
      }
      if (next.isPatrolCompleted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patrol completed!')),
        );
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Checkpoint')),
      body: Stack(
        children: [
          MobileScanner(
            controller: viewModel.scannerController,
            onDetect: viewModel.onDetect,
          ),
          _buildScannerOverlay(),
          if (state.isProcessing)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 4),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// --- State Notifier and State classes ---

class QRScannerState {
  final bool isProcessing;
  final String? scanResult;
  final bool isPatrolCompleted;
  final String? error;

  QRScannerState({
    this.isProcessing = false,
    this.scanResult,
    this.isPatrolCompleted = false,
    this.error,
  });

  QRScannerState copyWith({
    bool? isProcessing,
    String? scanResult,
    bool? isPatrolCompleted,
    String? error,
  }) {
    return QRScannerState(
      isProcessing: isProcessing ?? this.isProcessing,
      scanResult: scanResult,
      isPatrolCompleted: isPatrolCompleted ?? this.isPatrolCompleted,
      error: error,
    );
  }
}

class QRScannerViewModel extends StateNotifier<QRScannerState> {
  final Ref _ref;
  final Patrol patrol;
  final MobileScannerController scannerController = MobileScannerController();

  QRScannerViewModel(this._ref, this.patrol) : super(QRScannerState());

  void onDetect(BarcodeCapture capture) {
    if (state.isProcessing) return;

    final code = capture.barcodes.first.rawValue;
    if (code == null) return;

    final matchingCheckpoints = patrol.checkpoints.where(
      (cp) => cp.qrCode == code && !cp.completed,
    );

    if (matchingCheckpoints.isNotEmpty) {
      _logCheckpoint(matchingCheckpoints.first);
    }
  }

  Future<void> _logCheckpoint(Checkpoint checkpoint) async {
    state = state.copyWith(isProcessing: true, error: null, scanResult: null);

    try {
      final location = await _ref.read(locationServiceProvider).getCurrentLocation();
      final shiftId = await _ref.read(authServiceProvider).getCurrentShiftId();

      await _ref.read(patrolRepositoryProvider).logCheckpointScanOnline(
        checkpointId: checkpoint.id,
        shiftId: shiftId,
        latitude: location.latitude,
        longitude: location.longitude,
      );

      final updatedCheckpoints = patrol.checkpoints.map((cp) {
        return cp.id == checkpoint.id ? cp.copyWith(completed: true) : cp;
      }).toList();

      patrol.checkpoints.clear();
      patrol.checkpoints.addAll(updatedCheckpoints);

      final isCompleted = updatedCheckpoints.every((cp) => cp.completed);

      state = state.copyWith(
        isProcessing: false,
        scanResult: checkpoint.name,
        isPatrolCompleted: isCompleted,
      );
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
    }
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }
}

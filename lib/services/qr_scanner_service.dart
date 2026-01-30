import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../core/utils/logger.dart';

/// QR Code scanner service for checkpoint validation
class QRScannerService {
  /// Scan QR code and return the scanned data
  /// Returns null if scan was cancelled
  static Future<String?> scanQRCode(BuildContext context) async {
    final completer = Completer<String?>();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _QRScannerScreen(
          onScanned: (String code) {
            if (!completer.isCompleted) {
              completer.complete(code);
            }
          },
          onCancel: () {
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          },
        ),
      ),
    );

    return completer.future;
  }

  /// Validate if scanned QR code matches expected checkpoint code
  static bool validateCheckpointCode({
    required String scannedCode,
    required String expectedCode,
  }) {
    // Exact match
    if (scannedCode.trim().toLowerCase() == expectedCode.trim().toLowerCase()) {
      return true;
    }

    // Check if it's a URL containing the code
    if (scannedCode.contains(expectedCode)) {
      return true;
    }

    return false;
  }
}

/// QR Scanner Screen Widget
class _QRScannerScreen extends StatefulWidget {
  final Function(String) onScanned;
  final VoidCallback onCancel;

  const _QRScannerScreen({required this.onScanned, required this.onCancel});

  @override
  State<_QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<_QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null && code.isNotEmpty) {
      setState(() {
        _isProcessing = true;
      });

      AppLogger.info('QR Code scanned: $code');

      // Close the scanner and return the code
      Navigator.of(context).pop();
      widget.onScanned(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Checkpoint QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onCancel();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _controller.torchEnabled ? Icons.flash_on : Icons.flash_off,
            ),
            onPressed: () {
              _controller.toggleTorch();
              setState(() {});
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(controller: _controller, onDetect: _handleBarcode),

          // Overlay with scanning frame
          CustomPaint(painter: _ScannerOverlayPainter(), child: Container()),

          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Position QR code within the frame',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Manual entry button
                  OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final code = await _showManualEntryDialog(context);
                      if (code != null && code.isNotEmpty) {
                        widget.onScanned(code);
                      } else {
                        widget.onCancel();
                      }
                    },
                    icon: const Icon(Icons.keyboard, color: Colors.white),
                    label: const Text(
                      'Enter Code Manually',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showManualEntryDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Checkpoint Code'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Checkpoint Code',
            hintText: 'Enter code from checkpoint',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for scanner overlay
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;

    // Draw semi-transparent overlay
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Cut out the scan area
    final scanAreaRect = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);
    canvas.drawRect(scanAreaRect, Paint()..blendMode = BlendMode.clear);

    // Draw corners
    final cornerPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final cornerLength = 30.0;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerLength),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize - cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize, top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left + cornerLength, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left, top + scanAreaSize - cornerLength),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize),
      Offset(left + scanAreaSize - cornerLength, top + scanAreaSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize),
      Offset(left + scanAreaSize, top + scanAreaSize - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

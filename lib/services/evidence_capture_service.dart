import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import '../core/utils/logger.dart';

/// Evidence capture service for checkpoint photos and incident reporting
class EvidenceCaptureService {
  final ImagePicker _picker = ImagePicker();

  /// Capture photo for checkpoint evidence
  /// Returns the local file path of the saved photo
  Future<String?> captureCheckpointPhoto({
    required String checkpointId,
    required String patrolInstanceId,
  }) async {
    try {
      // Capture photo
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo == null) {
        AppLogger.info('Photo capture cancelled');
        return null;
      }

      // Read and compress the photo
      final bytes = await photo.readAsBytes();
      final compressed = await _compressImage(bytes);

      // Save to app directory
      final filePath = await _savePhoto(
        compressed,
        checkpointId: checkpointId,
        patrolInstanceId: patrolInstanceId,
      );

      AppLogger.info('Photo captured and saved: $filePath');
      return filePath;
    } catch (e) {
      AppLogger.error('Error capturing photo', e);
      return null;
    }
  }

  /// Select photo from gallery
  Future<String?> selectPhotoFromGallery({
    required String checkpointId,
    required String patrolInstanceId,
  }) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo == null) return null;

      // Read and compress
      final bytes = await photo.readAsBytes();
      final compressed = await _compressImage(bytes);

      // Save to app directory
      final filePath = await _savePhoto(
        compressed,
        checkpointId: checkpointId,
        patrolInstanceId: patrolInstanceId,
      );

      AppLogger.info('Photo selected and saved: $filePath');
      return filePath;
    } catch (e) {
      AppLogger.error('Error selecting photo', e);
      return null;
    }
  }

  /// Compress image to reduce file size
  Future<Uint8List> _compressImage(Uint8List imageBytes) async {
    try {
      // Decode image
      final image = img.decodeImage(imageBytes);
      if (image == null) return imageBytes;

      // Resize if too large (max 1920x1080)
      img.Image resized = image;
      if (image.width > 1920 || image.height > 1080) {
        resized = img.copyResize(
          image,
          width: image.width > image.height ? 1920 : null,
          height: image.height > image.width ? 1080 : null,
        );
      }

      // Compress to JPEG with 85% quality
      final compressed = img.encodeJpg(resized, quality: 85);

      final originalSize = imageBytes.length / 1024; // KB
      final compressedSize = compressed.length / 1024; // KB
      final ratio = (compressedSize / originalSize * 100).toStringAsFixed(1);

      AppLogger.info(
        'Image compressed: ${originalSize.toStringAsFixed(1)}KB → ${compressedSize.toStringAsFixed(1)}KB ($ratio%)',
      );

      return Uint8List.fromList(compressed);
    } catch (e) {
      AppLogger.error('Error compressing image', e);
      return imageBytes;
    }
  }

  /// Save photo to local storage
  Future<String> _savePhoto(
    Uint8List photoBytes, {
    required String checkpointId,
    required String patrolInstanceId,
  }) async {
    try {
      // Get app documents directory
      final appDir = await getApplicationDocumentsDirectory();

      // Create patrol photos directory
      final photoDir = Directory(
        '${appDir.path}/patrol_photos/$patrolInstanceId',
      );
      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }

      // Generate filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = '${checkpointId}_$timestamp.jpg';
      final filePath = '${photoDir.path}/$filename';

      // Write file
      final file = File(filePath);
      await file.writeAsBytes(photoBytes);

      AppLogger.debug('Photo saved to: $filePath');
      return filePath;
    } catch (e) {
      AppLogger.error('Error saving photo', e);
      rethrow;
    }
  }

  /// Delete photo file
  Future<void> deletePhoto(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        AppLogger.info('Photo deleted: $filePath');
      }
    } catch (e) {
      AppLogger.error('Error deleting photo', e);
    }
  }

  /// Get photo file size in KB
  Future<double> getPhotoSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final size = await file.length();
        return size / 1024; // Convert to KB
      }
      return 0;
    } catch (e) {
      AppLogger.error('Error getting photo size', e);
      return 0;
    }
  }

  /// Show photo capture options dialog
  Future<String?> showPhotoCaptureOptions({
    required BuildContext context,
    required String checkpointId,
    required String patrolInstanceId,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final path = await captureCheckpointPhoto(
                  checkpointId: checkpointId,
                  patrolInstanceId: patrolInstanceId,
                );
                Navigator.pop(context, path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final path = await selectPhotoFromGallery(
                  checkpointId: checkpointId,
                  patrolInstanceId: patrolInstanceId,
                );
                Navigator.pop(context, path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.grey),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );

    return result;
  }
}

/// Evidence photo widget for display
class EvidencePhotoWidget extends StatelessWidget {
  final String photoPath;
  final VoidCallback? onDelete;
  final double size;

  const EvidencePhotoWidget({
    super.key,
    required this.photoPath,
    this.onDelete,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(photoPath),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: size,
                height: size,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              );
            },
          ),
        ),
        if (onDelete != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
      ],
    );
  }
}

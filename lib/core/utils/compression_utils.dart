import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';

/// Compression utilities for location data
class CompressionUtils {
  /// Compress location batch to gzip format
  /// Returns compressed bytes ready for transmission
  static List<int> compressLocationBatch(List<Map<String, dynamic>> locations) {
    // Convert to JSON
    final jsonString = jsonEncode(locations);

    // Convert to bytes
    final bytes = utf8.encode(jsonString);

    // Compress with gzip
    final compressed = GZipEncoder().encode(bytes);

    return compressed ?? bytes; // Fallback to uncompressed if compression fails
  }

  /// Decompress location batch from gzip format
  static List<Map<String, dynamic>> decompressLocationBatch(
    List<int> compressedData,
  ) {
    try {
      // Decompress
      final decompressed = GZipDecoder().decodeBytes(compressedData);

      // Convert to string
      final jsonString = utf8.decode(decompressed);

      // Parse JSON
      final List<dynamic> jsonList = jsonDecode(jsonString);

      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      // If decompression fails, assume it's already decompressed JSON
      try {
        final jsonString = utf8.decode(compressedData);
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.cast<Map<String, dynamic>>();
      } catch (_) {
        rethrow;
      }
    }
  }

  /// Calculate compression ratio
  static double getCompressionRatio(List<int> original, List<int> compressed) {
    if (original.isEmpty) return 1.0;
    return compressed.length / original.length;
  }

  /// Get compressed size in KB
  static double getCompressedSizeKB(List<int> compressedData) {
    return compressedData.length / 1024;
  }
}

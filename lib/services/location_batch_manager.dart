import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/compression_utils.dart';
import '../../data/database/app_database.dart';
import '../../main.dart'
    hide
        dioClientProvider; // For databaseProvider, hiding dioClientProvider to avoid conflict

final locationBatchManagerProvider = Provider<LocationBatchManager>((ref) {
  final database = ref.watch(databaseProvider);
  final dioClient = ref.watch(dioClientProvider);
  return LocationBatchManager(database, dioClient);
});

/// Location batch manager for efficient syncing
class LocationBatchManager {
  final AppDatabase _database;
  final DioClient _dioClient;

  // Configuration
  static const int defaultBatchSize = 50;
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxBatchSizeBytes = 100 * 1024; // 100KB max batch size

  Timer? _syncTimer;
  bool _isSyncing = false;

  LocationBatchManager(this._database, this._dioClient);

  /// Start periodic batch sync
  void startPeriodicSync() {
    stop(); // Stop any existing timer

    _syncTimer = Timer.periodic(syncInterval, (_) {
      _syncBatch();
    });

    AppLogger.info(
      'Location batch manager started (sync every ${syncInterval.inMinutes} min)',
    );
  }

  /// Stop periodic sync
  void stop() {
    _syncTimer?.cancel();
    _syncTimer = null;
    AppLogger.info('Location batch manager stopped');
  }

  /// Get batch of locations ready for sync
  Future<LocationBatch?> getBatchForSync({int? batchSize}) async {
    try {
      final size = batchSize ?? defaultBatchSize;

      // Get unsynced locations
      final unsyncedLogs = await _database.locationLogsDao
          .getUnsyncedLocationLogs(limit: size);

      if (unsyncedLogs.isEmpty) {
        return null;
      }

      // Convert to JSON maps
      final locationMaps = unsyncedLogs
          .map(
            (log) => {
              'id': log.id,
              'employeeId': log.employeeId,
              'tenantId': log.tenantId,
              'shiftId': log.shiftId,
              'latitude': log.latitude,
              'longitude': log.longitude,
              'accuracy': log.accuracy,
              'altitude': log.altitude,
              'speed': log.speed,
              'timestamp': log.timestamp.toIso8601String(),
            },
          )
          .toList();

      // Compress batch
      final compressedData = CompressionUtils.compressLocationBatch(
        locationMaps,
      );

      // Calculate metadata
      final originalSize = locationMaps.toString().length;
      final compressionRatio = CompressionUtils.getCompressionRatio(
        locationMaps.toString().codeUnits,
        compressedData,
      );
      final compressedSizeKB = CompressionUtils.getCompressedSizeKB(
        compressedData,
      );

      AppLogger.info(
        'Location batch prepared: ${locationMaps.length} points, '
        '${compressedSizeKB.toStringAsFixed(1)}KB '
        '(${(compressionRatio * 100).toStringAsFixed(0)}% of original)',
      );

      return LocationBatch(
        locations: unsyncedLogs,
        compressedData: compressedData,
        count: locationMaps.length,
        compressedSizeKB: compressedSizeKB,
        compressionRatio: compressionRatio,
      );
    } catch (e) {
      AppLogger.error('Error getting location batch', e);
      return null;
    }
  }

  /// Sync batch to server
  Future<bool> _syncBatch() async {
    if (_isSyncing) {
      AppLogger.debug('Batch sync already in progress, skipping');
      return false;
    }

    _isSyncing = true;

    try {
      final batch = await getBatchForSync();

      if (batch == null || batch.count == 0) {
        AppLogger.debug('No locations to sync');
        return false;
      }

      AppLogger.info(
        'Syncing batch of ${batch.count} locations (${batch.compressedSizeKB.toStringAsFixed(1)}KB)',
      );

      // Send compressed batch to server
      final response = await _dioClient.dio.post(
        ApiEndpoints.bulkLocation,
        data: {
          'compressedData': batch.compressedData,
          'count': batch.count,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Mark locations as synced
        for (final location in batch.locations) {
          await _database.locationLogsDao.markAsSynced(location.id);
        }
        AppLogger.info('Successfully synced ${batch.count} locations');
        return true;
      } else {
        AppLogger.warning('Failed to sync batch: ${response.statusMessage}');
        return false;
      }
    } on DioException catch (e) {
      AppLogger.error('Network error syncing location batch', e);
      return false;
    } catch (e) {
      AppLogger.error('Unexpected error syncing location batch', e);
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Manual trigger for batch sync
  Future<bool> syncNow() async {
    return await _syncBatch();
  }

  /// Get sync status
  Future<BatchSyncStatus> getSyncStatus() async {
    final unsyncedCount = await _database.locationLogsDao.getUnsyncedCount();
    final totalCount = await _database.locationLogsDao.getTotalCount();

    return BatchSyncStatus(
      unsyncedCount: unsyncedCount,
      totalCount: totalCount,
      isSyncing: _isSyncing,
      nextSyncIn: _syncTimer != null
          ? syncInterval -
                Duration(
                  milliseconds:
                      DateTime.now().millisecondsSinceEpoch %
                      syncInterval.inMilliseconds,
                )
          : null,
    );
  }

  void dispose() {
    stop();
  }
}

/// Location batch data
class LocationBatch {
  final List<LocationLog> locations;
  final List<int> compressedData;
  final int count;
  final double compressedSizeKB;
  final double compressionRatio;

  LocationBatch({
    required this.locations,
    required this.compressedData,
    required this.count,
    required this.compressedSizeKB,
    required this.compressionRatio,
  });
}

/// Batch sync status
class BatchSyncStatus {
  final int unsyncedCount;
  final int totalCount;
  final bool isSyncing;
  final Duration? nextSyncIn;

  BatchSyncStatus({
    required this.unsyncedCount,
    required this.totalCount,
    required this.isSyncing,
    this.nextSyncIn,
  });

  bool get hasPendingSync => unsyncedCount > 0;
  int get syncedCount => totalCount - unsyncedCount;
  double get syncProgress => totalCount > 0 ? syncedCount / totalCount : 0.0;
}

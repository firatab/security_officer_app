import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/api_endpoints.dart';
import '../core/errors/exceptions.dart';
import '../core/network/dio_client.dart';
import '../core/utils/logger.dart';
import '../data/database/app_database.dart';
import '../data/database/tables/sync_queue.dart';

class SyncService {
  final DioClient _dioClient;
  final AppDatabase _database;
  final _uuid = const Uuid();

  bool _isSyncing = false;

  SyncService(this._dioClient, this._database);

  /// Check if device is online
  Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.isNotEmpty &&
           !connectivityResult.contains(ConnectivityResult.none);
  }

  /// Process all pending sync items (priority-ordered)
  Future<SyncResult> processSyncQueue() async {
    if (_isSyncing) {
      AppLogger.debug('Sync already in progress, skipping');
      return SyncResult(processed: 0, failed: 0, skipped: 0);
    }

    if (!await isOnline()) {
      AppLogger.debug('Device is offline, skipping sync');
      return SyncResult(processed: 0, failed: 0, skipped: 0);
    }

    _isSyncing = true;
    int processed = 0;
    int failed = 0;
    int skipped = 0;

    try {
      // Process critical priority items first (panic alerts, emergencies)
      final criticalResult = await _processPriorityQueue(SyncPriority.critical);
      processed += criticalResult.processed;
      failed += criticalResult.failed;

      // Process high priority items (check calls, attendance)
      final highResult = await _processPriorityQueue(SyncPriority.high);
      processed += highResult.processed;
      failed += highResult.failed;

      // Process normal priority items
      final normalResult = await _processPriorityQueue(SyncPriority.normal);
      processed += normalResult.processed;
      failed += normalResult.failed;

      // First, recover any pending locations from SharedPreferences (from background service fallback)
      await _recoverPendingLocationsFromPrefs();

      // Sync location logs (low priority background task)
      final locationsSynced = await _syncLocationLogs();
      processed += locationsSynced;

      // Sync check call responses
      final checkCallsSynced = await _syncCheckCallResponses();
      processed += checkCallsSynced;

      // Sync incident reports
      final incidentsSynced = await _syncIncidentReports();
      processed += incidentsSynced;

      // Sync patrol scans
      final patrolsSynced = await _syncPatrolScans();
      processed += patrolsSynced;

      AppLogger.info('Sync completed: processed=$processed, failed=$failed');
      return SyncResult(processed: processed, failed: failed, skipped: skipped);
    } catch (e) {
      AppLogger.error('Sync failed', e);
      throw SyncException('Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Process items of a specific priority
  Future<SyncResult> _processPriorityQueue(int priority) async {
    int processed = 0;
    int failed = 0;

    try {
      final pendingItems = await _database.syncQueueDao.getPendingByPriority(priority);

      if (pendingItems.isEmpty) {
        return SyncResult(processed: 0, failed: 0, skipped: 0);
      }

      AppLogger.info('Processing ${pendingItems.length} priority $priority items');

      for (final item in pendingItems) {
        try {
          // Mark as processing
          await _database.syncQueueDao.markAsProcessing(item.id);

          final success = await _processSyncItem(item);
          if (success) {
            processed++;
            await _database.syncQueueDao.markAsCompleted(item.id);
          } else {
            failed++;
            await _handleSyncFailure(item);
          }
        } catch (e) {
          AppLogger.error('Error processing sync item ${item.id}', e);
          failed++;
          await _handleSyncFailure(item, e.toString());
        }
      }
    } catch (e) {
      AppLogger.error('Error processing priority $priority queue', e);
    }

    return SyncResult(processed: processed, failed: failed, skipped: 0);
  }

  /// Handle sync failure with retry logic
  Future<void> _handleSyncFailure(SyncQueueData item, [String? errorMessage]) async {
    await _database.syncQueueDao.incrementRetryCount(item.id);

    if (item.retryCount + 1 >= item.maxRetries) {
      await _database.syncQueueDao.markAsFailed(
        item.id,
        errorMessage ?? 'Max retries exceeded',
      );
    } else {
      // Reset to pending for retry
      await _database.syncQueueDao.updateSyncItemStatus(
        item.id,
        'pending',
        errorMessage: errorMessage,
      );
    }
  }

  /// Process a single sync item
  Future<bool> _processSyncItem(SyncQueueData item) async {
    try {
      final payload = jsonDecode(item.payload) as Map<String, dynamic>;

      final response = await _dioClient.dio.request(
        item.endpoint,
        data: payload,
        options: Options(method: item.method),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.debug('Sync item ${item.id} processed successfully');

        // Handle conflict resolution if server returns updated data
        await _handleServerResponse(item, response.data);
        return true;
      } else if (response.statusCode == 409) {
        // Conflict - handle based on entity type
        await _handleConflict(item, response.data);
        return true; // Conflict handled
      } else {
        AppLogger.warning('Sync item ${item.id} failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      AppLogger.error('Error processing sync item ${item.id}', e);
      return false;
    }
  }

  /// Handle server response for conflict resolution
  Future<void> _handleServerResponse(SyncQueueData item, dynamic responseData) async {
    if (responseData == null) return;

    try {
      final data = responseData is Map<String, dynamic>
          ? responseData
          : jsonDecode(responseData.toString());

      // If server returned updated entity, update local database
      if (item.entityType != null && item.entityId != null && data['data'] != null) {
        await _updateLocalEntity(item.entityType!, item.entityId!, data['data']);
      }
    } catch (e) {
      AppLogger.error('Error handling server response', e);
    }
  }

  /// Handle conflict when server reports 409
  Future<void> _handleConflict(SyncQueueData item, dynamic conflictData) async {
    AppLogger.warning('Conflict detected for ${item.entityType}:${item.entityId}');

    // Strategy: Server wins for most entities (authoritative time tracking)
    // Re-queue with lower priority if local changes should be preserved

    try {
      switch (item.entityType) {
        case 'attendance':
          // Server wins for attendance (authoritative)
          if (conflictData != null && conflictData['serverData'] != null) {
            await _updateLocalEntity('attendance', item.entityId!, conflictData['serverData']);
          }
          break;

        case 'check_call':
          // Re-queue check call response if not synced
          if (conflictData != null && conflictData['shouldRetry'] == true) {
            await _reQueueWithDelay(item, Duration(seconds: 30));
          }
          break;

        case 'incident':
          // Merge strategy for incidents - local notes preserved
          if (conflictData != null && conflictData['serverData'] != null) {
            await _mergeIncidentData(item, conflictData['serverData']);
          }
          break;

        default:
          // Default: server wins
          AppLogger.info('Conflict resolved: server wins for ${item.entityType}');
      }
    } catch (e) {
      AppLogger.error('Error handling conflict', e);
    }
  }

  /// Update local entity with server data
  Future<void> _updateLocalEntity(String entityType, String entityId, Map<String, dynamic> data) async {
    // Implementation depends on entity type
    AppLogger.debug('Updating local $entityType:$entityId with server data');
    // This would update the specific table based on entityType
  }

  /// Re-queue item with delay
  Future<void> _reQueueWithDelay(SyncQueueData item, Duration delay) async {
    await _database.syncQueueDao.updateSyncItemStatus(item.id, 'pending');
    // The item will be processed on next sync cycle
    AppLogger.info('Re-queued sync item ${item.id} for retry');
  }

  /// Merge incident data (preserving local notes)
  Future<void> _mergeIncidentData(SyncQueueData item, Map<String, dynamic> serverData) async {
    try {
      final localPayload = jsonDecode(item.payload) as Map<String, dynamic>;

      // Merge: keep local notes, use server timestamps
      final merged = {
        ...serverData,
        'notes': localPayload['notes'] ?? serverData['notes'],
        'description': localPayload['description'] ?? serverData['description'],
      };

      // Update the sync queue item with merged data
      await (_database.update(_database.syncQueue)
            ..where((tbl) => tbl.id.equals(item.id)))
          .write(SyncQueueCompanion(
        payload: drift.Value(jsonEncode(merged)),
        status: const drift.Value('pending'),
      ));
    } catch (e) {
      AppLogger.error('Error merging incident data', e);
    }
  }

  /// Sync check call responses
  Future<int> _syncCheckCallResponses() async {
    try {
      final unsyncedCheckCalls = await _database.getUnsyncedCheckCalls();
      if (unsyncedCheckCalls.isEmpty) return 0;

      int synced = 0;
      for (final checkCall in unsyncedCheckCalls) {
        try {
          final response = await _dioClient.dio.post(
            '/api/shifts/${checkCall.shiftId}/check-calls',
            data: {
              'status': checkCall.status,
              'latitude': checkCall.latitude,
              'longitude': checkCall.longitude,
              'notes': checkCall.notes,
              'scheduledTime': checkCall.scheduledTime.toIso8601String(),
              'respondedAt': checkCall.respondedAt?.toIso8601String(),
            },
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await _database.markCheckCallSynced(checkCall.id);
            synced++;
          }
        } catch (e) {
          AppLogger.error('Error syncing check call ${checkCall.id}', e);
        }
      }

      if (synced > 0) {
        AppLogger.info('Synced $synced check calls');
      }
      return synced;
    } catch (e) {
      AppLogger.error('Error syncing check calls', e);
      return 0;
    }
  }

  /// Sync incident reports
  Future<int> _syncIncidentReports() async {
    try {
      final unsyncedIncidents = await _database.getUnsyncedIncidentReports(limit: 20);
      if (unsyncedIncidents.isEmpty) return 0;

      int synced = 0;
      for (final incident in unsyncedIncidents) {
        try {
          final response = await _dioClient.dio.post(
            '/api/incidents',
            data: {
              'siteId': incident.siteId,
              'incidentDate': incident.incidentDate.toIso8601String(),
              'incidentType': incident.incidentType,
              'severity': incident.severity,
              'title': incident.title,
              'description': incident.description,
              'location': incident.location,
              'actionTaken': incident.actionTaken,
              'policeNotified': incident.policeNotified,
              'policeRef': incident.policeRef,
            },
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            // Update local ID with server ID if returned
            final serverData = response.data['data'];
            if (serverData != null && serverData['id'] != null) {
              await _database.updateIncidentServerId(incident.id, serverData['id']);
            }
            await _database.markIncidentSynced(incident.id);
            synced++;
          }
        } catch (e) {
          AppLogger.error('Error syncing incident ${incident.id}', e);
        }
      }

      if (synced > 0) {
        AppLogger.info('Synced $synced incident reports');
      }
      return synced;
    } catch (e) {
      AppLogger.error('Error syncing incident reports', e);
      return 0;
    }
  }

  /// Sync patrol checkpoint scans
  Future<int> _syncPatrolScans() async {
    try {
      final unsyncedCheckpoints = await _database.getUnsyncedPatrolVisits();
      if (unsyncedCheckpoints.isEmpty) return 0;

      int synced = 0;
      for (final checkpoint in unsyncedCheckpoints) {
        try {
          final response = await _dioClient.dio.post(
            '/api/patrol/scan',
            data: {
              'code': checkpoint.qrCode,
              'checkpointId': checkpoint.id,
              'patrolId': checkpoint.patrolId,
              'latitude': checkpoint.latitude,
              'longitude': checkpoint.longitude,
              'visitedAt': checkpoint.completedAt?.toIso8601String(),
            },
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            await _database.markPatrolVisitSynced(checkpoint.id);
            synced++;
          }
        } catch (e) {
          AppLogger.error('Error syncing patrol checkpoint ${checkpoint.id}', e);
        }
      }

      if (synced > 0) {
        AppLogger.info('Synced $synced patrol checkpoint scans');
      }
      return synced;
    } catch (e) {
      AppLogger.error('Error syncing patrol checkpoint scans', e);
      return 0;
    }
  }

  /// Recover pending locations from SharedPreferences (when background service couldn't use database)
  Future<void> _recoverPendingLocationsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingJson = prefs.getStringList('pending_locations');

      if (pendingJson == null || pendingJson.isEmpty) {
        return;
      }

      AppLogger.info('Recovering ${pendingJson.length} pending locations from SharedPreferences');

      int recovered = 0;
      for (final jsonStr in pendingJson) {
        try {
          final data = jsonDecode(jsonStr) as Map<String, dynamic>;

          // Insert into database
          final companion = LocationLogsCompanion.insert(
            id: data['id'] as String? ?? _uuid.v4(),
            employeeId: data['employeeId'] as String,
            tenantId: data['tenantId'] as String,
            shiftId: drift.Value(data['shiftId'] as String?),
            latitude: (data['latitude'] as num).toDouble(),
            longitude: (data['longitude'] as num).toDouble(),
            accuracy: drift.Value((data['accuracy'] as num?)?.toDouble()),
            altitude: drift.Value((data['altitude'] as num?)?.toDouble()),
            speed: drift.Value((data['speed'] as num?)?.toDouble()),
            timestamp: data['timestamp'] != null
                ? DateTime.parse(data['timestamp'] as String)
                : DateTime.now(),
            needsSync: const drift.Value(true),
          );

          await _database.into(_database.locationLogs).insert(companion);
          recovered++;
        } catch (e) {
          AppLogger.error('Error recovering location from prefs', e);
        }
      }

      // Clear the pending locations from SharedPreferences
      await prefs.remove('pending_locations');
      AppLogger.info('Recovered $recovered pending locations from SharedPreferences');
    } catch (e) {
      AppLogger.error('Error recovering pending locations from SharedPreferences', e);
    }
  }

  /// Sync location logs to server
  Future<int> _syncLocationLogs() async {
    try {
      final unsyncedLogs = await _database.getUnsyncedLocationLogs(limit: 100);

      if (unsyncedLogs.isEmpty) {
        AppLogger.debug('No unsynced location logs to sync');
        return 0;
      }

      AppLogger.info('📍 Syncing ${unsyncedLogs.length} location logs to backend...');

      // Convert to API format
      final locationData = unsyncedLogs.map((log) => <String, dynamic>{
        'id': log.id,
        'employeeId': log.employeeId,
        'shiftId': log.shiftId,
        'tenantId': log.tenantId,
        'latitude': log.latitude,
        'longitude': log.longitude,
        'accuracy': log.accuracy,
        'altitude': log.altitude,
        'speed': log.speed,
        'timestamp': log.timestamp.toIso8601String(),
      }).toList();

      final response = await _dioClient.dio.post(
        ApiEndpoints.bulkLocation,
        data: {'locations': locationData},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Mark as synced
        final ids = unsyncedLogs.map((l) => l.id).toList();
        await (_database.update(_database.locationLogs)
              ..where((tbl) => tbl.id.isIn(ids)))
            .write(LocationLogsCompanion(
          needsSync: const drift.Value(false),
          syncedAt: drift.Value(DateTime.now()),
        ));

        AppLogger.info('✅ Successfully synced ${unsyncedLogs.length} location logs to backend');
        return unsyncedLogs.length;
      } else {
        AppLogger.warning('❌ Location sync failed with status: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      AppLogger.error('❌ Error syncing location logs to backend', e);
      return 0;
    }
  }

  /// Queue an operation for offline sync
  Future<void> queueForSync({
    required String operation,
    required String endpoint,
    required String method,
    required Map<String, dynamic> payload,
    int priority = SyncPriority.normal,
    String? entityType,
    String? entityId,
  }) async {
    // Check for existing item with same entity
    if (entityType != null && entityId != null) {
      final existing = await _database.syncQueueDao.findByEntity(entityType, entityId);
      if (existing != null) {
        // Update existing item instead of creating duplicate
        await (_database.update(_database.syncQueue)
              ..where((tbl) => tbl.id.equals(existing.id)))
            .write(SyncQueueCompanion(
          payload: drift.Value(jsonEncode(payload)),
          priority: drift.Value(priority),
          status: const drift.Value('pending'),
        ));
        AppLogger.debug('Updated existing sync item for $entityType:$entityId');
        return;
      }
    }

    final companion = SyncQueueCompanion.insert(
      id: _uuid.v4(),
      operation: operation,
      endpoint: endpoint,
      method: method,
      payload: jsonEncode(payload),
      priority: drift.Value(priority),
      entityType: drift.Value(entityType),
      entityId: drift.Value(entityId),
      createdAt: DateTime.now(),
    );

    await _database.into(_database.syncQueue).insert(companion);
    AppLogger.debug('Queued $operation for sync (priority: $priority)');
  }

  /// Queue a critical operation (panic alert, emergency)
  Future<void> queueCritical({
    required String operation,
    required String endpoint,
    required String method,
    required Map<String, dynamic> payload,
    String? entityType,
    String? entityId,
  }) async {
    await queueForSync(
      operation: operation,
      endpoint: endpoint,
      method: method,
      payload: payload,
      priority: SyncPriority.critical,
      entityType: entityType,
      entityId: entityId,
    );
  }

  /// Queue a high priority operation (check call, attendance)
  Future<void> queueHighPriority({
    required String operation,
    required String endpoint,
    required String method,
    required Map<String, dynamic> payload,
    String? entityType,
    String? entityId,
  }) async {
    await queueForSync(
      operation: operation,
      endpoint: endpoint,
      method: method,
      payload: payload,
      priority: SyncPriority.high,
      entityType: entityType,
      entityId: entityId,
    );
  }

  /// Public method to sync location logs
  Future<int> syncLocationLogs() async {
    if (!await isOnline()) {
      return 0;
    }
    return await _syncLocationLogs();
  }

  /// Add a location log to database
  Future<void> addLocationLog({
    required String employeeId,
    required String tenantId,
    String? shiftId,
    required double latitude,
    required double longitude,
    double? accuracy,
    double? altitude,
    double? speed,
  }) async {
    final companion = LocationLogsCompanion.insert(
      id: _uuid.v4(),
      employeeId: employeeId,
      tenantId: tenantId,
      shiftId: drift.Value(shiftId),
      latitude: latitude,
      longitude: longitude,
      accuracy: drift.Value(accuracy),
      altitude: drift.Value(altitude),
      speed: drift.Value(speed),
      timestamp: DateTime.now(),
      needsSync: const drift.Value(true),
    );

    await _database.into(_database.locationLogs).insert(companion);
    AppLogger.debug('Location log added: $latitude, $longitude');
  }

  /// Clean up old synced data
  Future<void> cleanupOldData({int daysToKeep = 30}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

    // Delete old synced location logs
    await (_database.delete(_database.locationLogs)
          ..where((tbl) => tbl.needsSync.equals(false))
          ..where((tbl) => tbl.timestamp.isSmallerOrEqual(drift.Variable(cutoffDate))))
        .go();

    // Delete old completed sync items
    await _database.syncQueueDao.deleteOldCompletedItems(Duration(days: daysToKeep));

    // Delete old failed sync items (after 7 days)
    final failedCutoff = DateTime.now().subtract(const Duration(days: 7));
    await (_database.delete(_database.syncQueue)
          ..where((tbl) => tbl.status.equals('failed'))
          ..where((tbl) => tbl.createdAt.isSmallerOrEqual(drift.Variable(failedCutoff))))
        .go();

    AppLogger.info('Cleaned up old data older than $daysToKeep days');
  }

  /// Get sync status with priority breakdown
  Future<SyncStatus> getSyncStatus() async {
    final criticalCount = await _database.syncQueueDao.getPendingCountByPriority(SyncPriority.critical);
    final highCount = await _database.syncQueueDao.getPendingCountByPriority(SyncPriority.high);
    final normalCount = await _database.syncQueueDao.getPendingCountByPriority(SyncPriority.normal);
    final unsyncedLogs = await _database.getUnsyncedLocationLogs(limit: 1000);

    final failedItems = await (_database.select(_database.syncQueue)
          ..where((tbl) => tbl.status.equals('failed')))
        .get();

    return SyncStatus(
      criticalPending: criticalCount,
      highPriorityPending: highCount,
      normalPending: normalCount,
      unsyncedLocationLogs: unsyncedLogs.length,
      failedOperations: failedItems.length,
      isOnline: await isOnline(),
    );
  }
}

/// Sync result
class SyncResult {
  final int processed;
  final int failed;
  final int skipped;

  SyncResult({
    required this.processed,
    required this.failed,
    required this.skipped,
  });
}

/// Enhanced sync status with priority breakdown
class SyncStatus {
  final int criticalPending;
  final int highPriorityPending;
  final int normalPending;
  final int unsyncedLocationLogs;
  final int failedOperations;
  final bool isOnline;

  SyncStatus({
    required this.criticalPending,
    required this.highPriorityPending,
    required this.normalPending,
    required this.unsyncedLocationLogs,
    required this.failedOperations,
    required this.isOnline,
  });

  int get pendingOperations => criticalPending + highPriorityPending + normalPending;

  bool get hasPendingSync =>
      pendingOperations > 0 || unsyncedLocationLogs > 0;

  int get totalPending => pendingOperations + unsyncedLocationLogs;

  bool get hasCritical => criticalPending > 0;
}

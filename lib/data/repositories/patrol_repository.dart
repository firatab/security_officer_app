import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:security_officer_app/data/models/patrol.dart' as models;

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/logger.dart';
import '../database/app_database.dart';

class PatrolRepository {
  final DioClient _dioClient;
  final AppDatabase _database;

  PatrolRepository(this._dioClient, this._database);

  /// Fetch patrols for a given site from the API
  Future<List<models.Patrol>> fetchPatrolsForSite(String siteId) async {
    try {
      final response = await _dioClient.dio.get('${ApiEndpoints.sites}/$siteId/patrols');
      if (response.statusCode == 200) {
        // Backend returns { success: true, data: [...] } or { patrols: [...] }
        final responseData = response.data as Map<String, dynamic>?;
        final patrolsData = (responseData?['data'] ?? responseData?['patrols'] ?? []) as List;
        final patrols = patrolsData.map((data) => models.Patrol.fromJson(data as Map<String, dynamic>)).toList();
        await _savePatrolsToDatabase(patrols);
        return patrols;
      } else {
        throw NetworkException('Failed to fetch patrols: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      AppLogger.error('Fetch patrols API call failed', e);
      throw NetworkException('Network error fetching patrols: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected error fetching patrols', e);
      throw AppException('Failed to fetch patrols: $e');
    }
  }

  /// Save patrols and their checkpoints to the local database
  Future<void> _savePatrolsToDatabase(List<models.Patrol> patrols) async {
    await _database.transaction(() async {
      for (final patrol in patrols) {
        final patrolCompanion = PatrolsCompanion.insert(
          id: patrol.id,
          siteId: patrol.siteId,
          name: patrol.name,
          description: drift.Value(patrol.description),
        );
        await _database.into(_database.patrols).insertOnConflictUpdate(patrolCompanion);

        for (final checkpoint in patrol.checkpoints) {
          final checkpointCompanion = CheckpointsCompanion.insert(
            id: checkpoint.id,
            patrolId: patrol.id,
            name: checkpoint.name,
            instructions: drift.Value(checkpoint.instructions),
            latitude: drift.Value(checkpoint.latitude),
            longitude: drift.Value(checkpoint.longitude),
            qrCode: drift.Value(checkpoint.qrCode),
          );
          await _database.into(_database.checkpoints).insertOnConflictUpdate(checkpointCompanion);
        }
      }
    });
  }

  /// Log a checkpoint scan - online
  Future<void> logCheckpointScanOnline({
    required String checkpointId,
    required String shiftId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.patrols}/checkpoints/$checkpointId/scan',
        data: {
          'shiftId': shiftId,
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        // Update local record
        await _markCheckpointCompleted(checkpointId);
        AppLogger.info('Checkpoint scan logged successfully online: $checkpointId');
      } else {
        throw NetworkException('Failed to log checkpoint scan: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      AppLogger.error('Log checkpoint scan API call failed', e);
      throw NetworkException('Network error logging checkpoint scan: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected error logging checkpoint scan', e);
      throw AppException('Failed to log checkpoint scan: $e');
    }
  }

  /// Mark a checkpoint as completed in the local database
  Future<void> _markCheckpointCompleted(String checkpointId) async {
    await (_database.update(_database.checkpoints)..where((c) => c.id.equals(checkpointId))).write(
      CheckpointsCompanion(
        completed: const drift.Value(true),
        completedAt: drift.Value(DateTime.now()),
      ),
    );
  }
}

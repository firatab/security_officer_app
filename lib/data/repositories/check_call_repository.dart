import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/logger.dart';
import '../database/app_database.dart';
import '../database/tables/sync_queue.dart';

class CheckCallRepository {
  final DioClient _dioClient;
  final AppDatabase _database;
  final _uuid = const Uuid();

  CheckCallRepository(this._dioClient, this._database);

  Future<List<CheckCall>> getCheckCallsForShift(String shiftId) async {
    return await _database.checkCallsDao.getCheckCallsForShift(shiftId);
  }

  /// Create check calls for a shift based on frequency
  Future<void> createCheckCallsForShift({
    required String shiftId,
    required String employeeId,
    required String tenantId,
    required DateTime startTime,
    required DateTime endTime,
    required int frequencyMinutes,
  }) async {
    final checkCalls = <CheckCallsCompanion>[];
    var scheduledTime = startTime.add(Duration(minutes: frequencyMinutes));

    while (scheduledTime.isBefore(endTime)) {
      checkCalls.add(CheckCallsCompanion.insert(
        id: _uuid.v4(),
        shiftId: shiftId,
        employeeId: employeeId,
        tenantId: tenantId,
        scheduledTime: scheduledTime,
        status: const Value('pending'),
        createdAt: DateTime.now(),
      ));
      scheduledTime = scheduledTime.add(Duration(minutes: frequencyMinutes));
    }

    // Insert all check calls
    for (final companion in checkCalls) {
      await _database.checkCallsDao.insertCheckCall(companion);
    }

    AppLogger.info('Created ${checkCalls.length} check calls for shift $shiftId');
  }

  Future<List<CheckCall>> getPendingCheckCalls(String employeeId) async {
    return await _database.checkCallsDao.getPendingCheckCalls(employeeId);
  }

  Future<void> respondToCheckCallOnline({
    required String checkCallId,
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      await _dioClient.post(
        ApiEndpoints.checkCallRespond(checkCallId),
        data: {
          'latitude': latitude,
          'longitude': longitude,
          'notes': notes,
        },
      );
    } catch (e) {
      AppLogger.error('Error responding to check call online, saving offline', e);
      await _database.checkCallsDao.respondToCheckCallOffline(
        checkCallId: checkCallId,
        latitude: latitude,
        longitude: longitude,
        notes: notes,
      );
    }
  }

  /// Respond to a check call with status
  /// This is the main method called from the check call response screen
  Future<void> respondToCheckCall({
    required String shiftId,
    required String checkCallId,
    required String status,
    String? notes,
    double? latitude,
    double? longitude,
  }) async {
    try {
      await _dioClient.post(
        ApiEndpoints.checkCallsForShift(shiftId),
        data: {
          'checkType': 'manual',
          'status': status,
          'latitude': latitude,
          'longitude': longitude,
          'notes': notes,
          'scheduledTime': DateTime.now().toIso8601String(),
        },
      );

      // Update local database
      await _database.checkCallsDao.updateCheckCallStatus(
        checkCallId,
        status == 'ok' ? 'answered' : status,
      );

      AppLogger.info('Check call $checkCallId responded with status: $status');
    } catch (e) {
      AppLogger.error('Error responding to check call, saving offline', e);

      // Save offline
      await _database.checkCallsDao.respondToCheckCallOffline(
        checkCallId: checkCallId,
        latitude: latitude ?? 0,
        longitude: longitude ?? 0,
        notes: notes,
      );

      // Add to sync queue with high priority
      await _database.syncQueueDao.insertSyncItem(
        SyncQueueCompanion.insert(
          id: _uuid.v4(),
          operation: 'check_call_response',
          endpoint: ApiEndpoints.checkCallsForShift(shiftId),
          method: 'POST',
          payload: jsonEncode({
            'shiftId': shiftId,
            'checkCallId': checkCallId,
            'status': status,
            'notes': notes,
            'latitude': latitude,
            'longitude': longitude,
            'timestamp': DateTime.now().toIso8601String(),
          }),
          entityType: const Value('check_call'),
          entityId: Value(checkCallId),
          priority: Value(SyncPriority.high),
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> markCheckCallMissed(String checkCallId) async {
    try {
      await _dioClient.post(ApiEndpoints.checkCallMissed(checkCallId));
    } catch (e) {
      AppLogger.error('Error marking check call missed online, saving offline', e);
      await _database.checkCallsDao.markCheckCallMissed(checkCallId);
    }
  }

  Future<Map<String, int>> getCheckCallStats(String shiftId) async {
    final checkCalls = await getCheckCallsForShift(shiftId);

    int answered = 0;
    int missed = 0;
    int pending = 0;

    for (final call in checkCalls) {
      switch (call.status) {
        case 'answered':
          answered++;
          break;
        case 'missed':
          missed++;
          break;
        default:
          pending++;
      }
    }

    return {
      'total': checkCalls.length,
      'answered': answered,
      'missed': missed,
      'pending': pending,
    };
  }
}

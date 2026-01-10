import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/logger.dart';
import '../database/app_database.dart';
import '../database/tables/sync_queue.dart';

class AttendanceRepository {
  final DioClient _dioClient;
  final AppDatabase _database;
  final _uuid = const Uuid();

  AttendanceRepository(this._dioClient, this._database);

  /// Book on (clock in) - online
  Future<Attendance> bookOnOnline({
    required String shiftId,
    required double latitude,
    required double longitude,
    String method = 'mobile',
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.bookOn,
        data: {
          'shiftId': shiftId,
          'latitude': latitude,
          'longitude': longitude,
          'method': method,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>?;
        // Backend returns { success: true, data: attendance, message: ... }
        final attendanceData = (responseData?['data'] ?? responseData?['attendance'] ?? responseData) as Map<String, dynamic>?;

        if (attendanceData == null) {
          throw AppException('Failed to book on: Invalid response format');
        }

        // Save to database
        final attendance = await _saveAttendanceToDatabase(
          attendanceData,
          needsSync: false,
        );

        AppLogger.info('Successfully booked on for shift $shiftId');
        return attendance;
      } else {
        throw NetworkException('Book on failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      AppLogger.error('Book on API call failed', e);

      if (e.response?.statusCode == 400) {
        final message = e.response?.data['error'] ?? 'Invalid request';
        throw ValidationException(message);
      } else if (e.response?.statusCode == 403) {
        throw ValidationException('You are not at the correct location to book on');
      }

      throw NetworkException('Network error during book on: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected error during book on', e);
      throw AppException('Failed to book on: $e');
    }
  }

  /// Book on (clock in) - offline
  Future<Attendance> bookOnOffline({
    required String shiftId,
    required String employeeId,
    required String tenantId,
    required double latitude,
    required double longitude,
    String method = 'mobile',
  }) async {
    try {
      final attendanceId = _uuid.v4();
      final now = DateTime.now();

      // Create attendance record
      final companion = AttendancesCompanion.insert(
        id: attendanceId,
        shiftId: shiftId,
        employeeId: employeeId,
        tenantId: tenantId,
        bookOnTime: drift.Value(now),
        bookOnLatitude: drift.Value(latitude),
        bookOnLongitude: drift.Value(longitude),
        bookOnMethod: drift.Value(method),
        status: drift.Value('on-duty'),
        createdAt: now,
        updatedAt: now,
        needsSync: drift.Value(true), // Mark for sync
      );

      await _database.into(_database.attendances).insert(companion);

      // Add to sync queue
      await _addToSyncQueue(
        operation: 'book_on',
        endpoint: ApiEndpoints.bookOn,
        payload: {
          'shiftId': shiftId,
          'latitude': latitude,
          'longitude': longitude,
          'method': method,
        },
        entityId: attendanceId,
      );

      final attendance = await _database.getAttendanceForShift(shiftId);
      AppLogger.info('Booked on offline for shift $shiftId');
      return attendance!;
    } catch (e) {
      AppLogger.error('Error booking on offline', e);
      throw DatabaseException('Failed to book on offline: $e');
    }
  }

  /// Book off (clock out) - via API
  Future<Attendance> bookOffApi({
    required String shiftId,
    required double latitude,
    required double longitude,
    String method = 'mobile',
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.bookOff,
        data: {
          'shiftId': shiftId,
          'latitude': latitude,
          'longitude': longitude,
          'method': method,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        // Backend returns { success: true, data: attendance, message: ... }
        final attendanceData = (responseData?['data'] ?? responseData?['attendance'] ?? responseData) as Map<String, dynamic>?;

        if (attendanceData == null) {
          throw AppException('Failed to book off: Invalid response format');
        }

        // Update in database
        final attendance = await _saveAttendanceToDatabase(
          attendanceData,
          needsSync: false,
        );

        AppLogger.info('Successfully booked off for shift $shiftId');
        return attendance;
      } else {
        throw NetworkException('Book off failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      AppLogger.error('Book off API call failed', e);

      if (e.response?.statusCode == 400) {
        final message = e.response?.data['error'] ?? 'Invalid request';
        throw ValidationException(message);
      } else if (e.response?.statusCode == 403) {
        throw ValidationException('You are not at the correct location to book off');
      }

      throw NetworkException('Network error during book off: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected error during book off', e);
      throw AppException('Failed to book off: $e');
    }
  }

  /// Book off (clock out) - offline
  Future<Attendance> bookOffOffline({
    required String shiftId,
    required double latitude,
    required double longitude,
    String method = 'mobile',
  }) async {
    try {
      final attendance = await _database.getAttendanceForShift(shiftId);
      if (attendance == null) {
        throw ValidationException('No attendance record found for this shift');
      }

      final now = DateTime.now();

      // Calculate hours (rough estimate without break)
      final hours = attendance.bookOnTime != null
          ? now.difference(attendance.bookOnTime!).inMinutes / 60.0
          : 0.0;

      // Update attendance record
      final updatedAttendance = attendance.copyWith(
        bookOffTime: drift.Value(now),
        bookOffLatitude: drift.Value(latitude),
        bookOffLongitude: drift.Value(longitude),
        bookOffMethod: drift.Value(method),
        status: 'completed',
        totalHours: drift.Value(hours),
        updatedAt: now,
        needsSync: true,
      );

      await _database.update(_database.attendances).replace(updatedAttendance);

      // Add to sync queue
      await _addToSyncQueue(
        operation: 'book_off',
        endpoint: ApiEndpoints.bookOff,
        payload: {
          'shiftId': shiftId,
          'latitude': latitude,
          'longitude': longitude,
          'method': method,
        },
        entityId: attendance.id,
      );

      AppLogger.info('Booked off offline for shift $shiftId');
      return updatedAttendance;
    } catch (e) {
      AppLogger.error('Error booking off offline', e);
      throw DatabaseException('Failed to book off offline: $e');
    }
  }

  /// Helper to safely parse a value that might be a number or string to double
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Helper to safely parse a value that might be a number or string to int
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Save attendance data from API to database
  Future<Attendance> _saveAttendanceToDatabase(
    Map<String, dynamic> data,
    {required bool needsSync}
  ) async {
    // Validate required fields
    final id = data['id'] as String?;
    final shiftId = data['shiftId'] as String?;
    final employeeId = data['employeeId'] as String?;
    final tenantId = data['tenantId'] as String?;

    if (id == null || shiftId == null || employeeId == null || tenantId == null) {
      throw AppException('Incomplete attendance data from server');
    }

    // Safely parse DateTime strings
    final bookOnTimeStr = data['bookOnTime'] as String?;
    final bookOffTimeStr = data['bookOffTime'] as String?;

    final companion = AttendancesCompanion.insert(
      id: id,
      shiftId: shiftId,
      employeeId: employeeId,
      tenantId: tenantId,
      bookOnTime: drift.Value(
        bookOnTimeStr != null ? DateTime.tryParse(bookOnTimeStr) : null,
      ),
      bookOnLatitude: drift.Value(_parseDouble(data['bookOnLatitude'])),
      bookOnLongitude: drift.Value(_parseDouble(data['bookOnLongitude'])),
      bookOnMethod: drift.Value(data['bookOnMethod'] as String?),
      bookOffTime: drift.Value(
        bookOffTimeStr != null ? DateTime.tryParse(bookOffTimeStr) : null,
      ),
      bookOffLatitude: drift.Value(_parseDouble(data['bookOffLatitude'])),
      bookOffLongitude: drift.Value(_parseDouble(data['bookOffLongitude'])),
      bookOffMethod: drift.Value(data['bookOffMethod'] as String?),
      status: drift.Value(data['status'] as String? ?? 'pending'),
      totalHours: drift.Value(_parseDouble(data['totalHours'])),
      isLate: drift.Value(data['isLate'] as bool? ?? false),
      lateMinutes: drift.Value(_parseInt(data['lateMinutes'])),
      autoBookedOff: drift.Value(data['autoBookedOff'] as bool? ?? false),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncedAt: drift.Value(DateTime.now()),
      needsSync: drift.Value(needsSync),
    );

    await _database.into(_database.attendances).insertOnConflictUpdate(companion);

    final savedAttendance = await _database.getAttendanceForShift(shiftId);
    if (savedAttendance == null) {
      throw DatabaseException('Failed to save and retrieve attendance record');
    }
    return savedAttendance;
  }

  /// Add operation to sync queue with high priority for attendance
  Future<void> _addToSyncQueue({
    required String operation,
    required String endpoint,
    required Map<String, dynamic> payload,
    String? entityId,
  }) async {
    final companion = SyncQueueCompanion.insert(
      id: _uuid.v4(),
      operation: operation,
      endpoint: endpoint,
      method: 'POST',
      payload: jsonEncode(payload),
      priority: drift.Value(SyncPriority.high), // Attendance is high priority
      entityType: const drift.Value('attendance'),
      entityId: drift.Value(entityId),
      createdAt: DateTime.now(),
    );

    await _database.into(_database.syncQueue).insert(companion);
    AppLogger.debug('Added $operation to sync queue (high priority)');
  }

  /// Get attendance for shift
  Future<Attendance?> getAttendanceForShift(String shiftId) async {
    return await _database.getAttendanceForShift(shiftId);
  }
}

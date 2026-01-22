import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/constants/api_endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/logger.dart';
import '../database/app_database.dart';
import '../models/shift_model.dart';

class ShiftRepository {
  final DioClient _dioClient;
  final AppDatabase _database;

  ShiftRepository(this._dioClient, this._database);

  /// Fetch shifts from API for a date range
  Future<List<ShiftModel>> fetchShiftsFromAPI({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await _dioClient.dio.get(
        ApiEndpoints.employeeShifts,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // Backend returns { success: true, data: [...], count: N }
        final List<dynamic> data = response.data['data'] ?? response.data['shifts'] ?? [];
        final shifts = data.map((json) => ShiftModel.fromJson(json)).toList();

        AppLogger.info('Fetched ${shifts.length} shifts from API');
        return shifts;
      } else {
        throw NetworkException('Failed to fetch shifts: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch shifts from API', e);
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected error fetching shifts', e);
      throw AppException('Failed to fetch shifts: $e');
    }
  }

  /// Save shifts to local database
  Future<void> saveShiftsToDatabase(List<ShiftModel> shifts) async {
    try {
      for (final shift in shifts) {
        final companion = ShiftsCompanion.insert(
          id: shift.id,
          tenantId: shift.tenantId ?? '',
          employeeId: shift.employeeId ?? '',
          siteId: shift.siteId,
          clientId: shift.clientId ?? shift.client?.id ?? '',
          siteName: shift.site.name,
          siteAddress: shift.site.address,
          siteLatitude: drift.Value(shift.site.latitude),
          siteLongitude: drift.Value(shift.site.longitude),
          clientName: shift.client?.name ?? 'Unknown Client',
          shiftDate: shift.shiftDate,
          startTime: shift.startTime,
          endTime: shift.endTime,
          breakMinutes: drift.Value(shift.breakMinutes),
          status: drift.Value(shift.status),
          checkCallEnabled: drift.Value(shift.site.checkCallEnabled),
          checkCallFrequency: drift.Value(shift.site.checkCallFrequency),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          syncedAt: drift.Value(DateTime.now()),
        );

        await _database.into(_database.shifts).insertOnConflictUpdate(companion);

        // Save attendance if exists
        if (shift.attendance != null) {
          final att = shift.attendance!;
          final attCompanion = AttendancesCompanion.insert(
            id: att.id,
            shiftId: shift.id,
            employeeId: shift.employeeId ?? '',
            tenantId: shift.tenantId ?? '',
            bookOnTime: drift.Value(att.bookOnTime),
            bookOffTime: drift.Value(att.bookOffTime),
            status: drift.Value(att.status),
            totalHours: drift.Value(att.totalHours),
            isLate: drift.Value(att.isLate),
            lateMinutes: drift.Value(att.lateMinutes),
            autoBookedOff: drift.Value(att.autoBookedOff),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            syncedAt: drift.Value(DateTime.now()),
            needsSync: drift.Value(false),
          );

          await _database.into(_database.attendances).insertOnConflictUpdate(attCompanion);
        }
      }

      AppLogger.info('Saved ${shifts.length} shifts to database');
    } catch (e) {
      AppLogger.error('Error saving shifts to database', e);
      throw DatabaseException('Failed to save shifts: $e');
    }
  }

  /// Get shifts from local database
  Future<List<Shift>> getShiftsFromDatabase({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
      final end = endDate ?? DateTime.now().add(const Duration(days: 30));

      final shifts = await _database.getShiftsInRange(start, end);
      AppLogger.debug('Retrieved ${shifts.length} shifts from database');
      return shifts;
    } catch (e) {
      AppLogger.error('Error retrieving shifts from database', e);
      throw DatabaseException('Failed to retrieve shifts: $e');
    }
  }

  /// Sync shifts: fetch from API and save to database
  /// This also removes shifts that no longer exist on the server
  Future<List<Shift>> syncShifts({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      // Fetch from API
      final apiShifts = await fetchShiftsFromAPI(
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );

      // Get IDs of shifts from API
      final apiShiftIds = apiShifts.map((s) => s.id).toSet();

      // Get current local shifts in the same date range
      final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
      final end = endDate ?? DateTime.now().add(const Duration(days: 30));
      final localShifts = await _database.getShiftsInRange(start, end);

      // Delete shifts that exist locally but not in API response (they were deleted on server)
      for (final localShift in localShifts) {
        if (!apiShiftIds.contains(localShift.id)) {
          AppLogger.info('Deleting shift ${localShift.id} - no longer exists on server');
          await (_database.delete(_database.shifts)
                ..where((tbl) => tbl.id.equals(localShift.id)))
              .go();
          // Also delete related attendance
          await (_database.delete(_database.attendances)
                ..where((tbl) => tbl.shiftId.equals(localShift.id)))
              .go();
        }
      }

      // Save new/updated shifts to database
      await saveShiftsToDatabase(apiShifts);

      // Return from database (to ensure consistency)
      return await getShiftsFromDatabase(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      AppLogger.warning('Sync failed, returning cached shifts', e);
      // If sync fails, return cached data
      return await getShiftsFromDatabase(
        startDate: startDate,
        endDate: endDate,
      );
    }
  }

  /// Fetch a single shift from API by ID
  Future<ShiftModel?> fetchShiftByIdFromAPI(String shiftId) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.employeeShifts}/$shiftId',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data['shift'];
        if (data != null) {
          final shift = ShiftModel.fromJson(data);
          AppLogger.info('Fetched shift $shiftId from API');
          return shift;
        }
      }
      return null;
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch shift by ID from API', e);
      return null;
    } catch (e) {
      AppLogger.error('Unexpected error fetching shift by ID', e);
      return null;
    }
  }

  /// Get shift by ID - tries local database first, then API as fallback
  Future<Shift?> getShiftById(String shiftId) async {
    try {
      // First, try to get from local database
      final localShift = await (_database.select(_database.shifts)
            ..where((tbl) => tbl.id.equals(shiftId)))
          .getSingleOrNull();

      if (localShift != null) {
        AppLogger.debug('Found shift $shiftId in local database');
        return localShift;
      }

      // If not found locally, try to fetch from API
      AppLogger.info('Shift $shiftId not in local database, fetching from API...');
      final apiShift = await fetchShiftByIdFromAPI(shiftId);
      
      if (apiShift != null) {
        // Save to database for future offline access
        await saveShiftsToDatabase([apiShift]);
        
        // Return the newly saved shift from database
        return await (_database.select(_database.shifts)
              ..where((tbl) => tbl.id.equals(shiftId)))
            .getSingleOrNull();
      }

      AppLogger.warning('Shift $shiftId not found in database or API');
      return null;
    } catch (e) {
      AppLogger.error('Error getting shift by ID', e);
      return null;
    }
  }

  /// Get attendance for shift
  Future<Attendance?> getAttendanceForShift(String shiftId) async {
    return await _database.getAttendanceForShift(shiftId);
  }

  /// Get shifts in a date range (from local database)
  Future<List<Shift>> getShiftsInRange(DateTime start, DateTime end) async {
    return await _database.getShiftsInRange(start, end);
  }
}

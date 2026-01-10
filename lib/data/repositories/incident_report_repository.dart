import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/logger.dart';
import '../database/app_database.dart';

class IncidentReportRepository {
  final DioClient _dioClient;
  final AppDatabase _database;
  final _uuid = const Uuid();

  IncidentReportRepository(this._dioClient, this._database);

  /// Create incident report - online
  Future<IncidentReport> createIncidentReportOnline({
    required String shiftId,
    required String employeeId,
    required String tenantId,
    required double latitude,
    required double longitude,
    required String incidentType,
    required String description,
    required String severity,
    List<File>? mediaFiles,
  }) async {
    try {
      final formData = FormData.fromMap({
        'shiftId': shiftId,
        'employeeId': employeeId,
        'tenantId': tenantId,
        'latitude': latitude,
        'longitude': longitude,
        'incidentType': incidentType,
        'description': description,
        'severity': severity,
        'reportTime': DateTime.now().toIso8601String(),
      });

      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (var i = 0; i < mediaFiles.length; i++) {
          final file = mediaFiles[i];
          formData.files.add(MapEntry(
            'media',
            await MultipartFile.fromFile(file.path),
          ));
        }
      }

      final response = await _dioClient.dio.post(
        ApiEndpoints.incidentReports,
        data: formData,
      );

      if (response.statusCode == 201) {
        final reportData = response.data['incidentReport'] as Map<String, dynamic>;
        final incidentReport = await _saveReportToDatabase(reportData, needsSync: false);
        AppLogger.info('Incident report created successfully online: ${incidentReport.id}');
        return incidentReport;
      } else {
        throw NetworkException('Failed to create incident report: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      AppLogger.error('Create incident report API call failed', e);
      throw NetworkException('Network error creating incident report: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected error creating incident report online', e);
      throw AppException('Failed to create incident report: $e');
    }
  }

  /// Create incident report - offline
  Future<IncidentReport> createIncidentReportOffline({
    required String shiftId,
    required String siteId,
    required String employeeId,
    required String tenantId,
    required String title,
    required double latitude,
    required double longitude,
    String? location,
    required String incidentType,
    required String description,
    required String severity,
    String? actionTaken,
    bool policeNotified = false,
    String? policeRef,
    List<String>? mediaFilePaths,
  }) async {
    try {
      final now = DateTime.now();
      final reportId = _uuid.v4();

      final companion = IncidentReportsCompanion.insert(
        id: reportId,
        shiftId: shiftId,
        siteId: siteId,
        employeeId: employeeId,
        tenantId: tenantId,
        title: title,
        incidentDate: now,
        reportTime: now,
        latitude: latitude,
        longitude: longitude,
        location: Value(location),
        incidentType: incidentType,
        description: description,
        severity: severity,
        actionTaken: Value(actionTaken),
        policeNotified: Value(policeNotified),
        policeRef: Value(policeRef),
        mediaFilePaths: mediaFilePaths != null ? Value(jsonEncode(mediaFilePaths)) : const Value.absent(),
        needsSync: const Value(true),
      );

      await _database.into(_database.incidentReports).insert(companion);
      final report = await (_database.select(_database.incidentReports)..where((tbl) => tbl.id.equals(reportId))).getSingle();

      AppLogger.info('Incident report saved offline: ${report.id}');
      return report;
    } catch (e) {
      AppLogger.error('Error saving incident report offline', e);
      throw DatabaseException('Failed to save incident report offline: $e');
    }
  }

  /// Get unsynced incident reports
  Future<List<IncidentReport>> getUnsyncedReports({int limit = 50}) {
    return _database.getUnsyncedIncidentReports(limit: limit);
  }

  /// Mark report as synced
  Future<void> markAsSynced(String id) {
    return _database.incidentReportsDao.markAsSynced(id);
  }

  /// Save report data from API to database
  Future<IncidentReport> _saveReportToDatabase(
    Map<String, dynamic> data,
    {required bool needsSync}
  ) async {
    final mediaUrls = data['mediaUrls'] as List<dynamic>?;
    final companion = IncidentReportsCompanion.insert(
      id: data['id'],
      serverId: Value(data['serverId'] as String?),
      shiftId: data['shiftId'],
      siteId: data['siteId'] ?? '',
      employeeId: data['employeeId'],
      tenantId: data['tenantId'],
      title: data['title'] ?? 'Incident Report',
      incidentDate: data['incidentDate'] != null
          ? DateTime.parse(data['incidentDate'])
          : DateTime.parse(data['reportTime']),
      reportTime: DateTime.parse(data['reportTime']),
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      location: Value(data['location'] as String?),
      incidentType: data['incidentType'],
      description: data['description'],
      severity: data['severity'],
      actionTaken: Value(data['actionTaken'] as String?),
      policeNotified: Value(data['policeNotified'] as bool? ?? false),
      policeRef: Value(data['policeRef'] as String?),
      mediaUrls: mediaUrls != null ? Value(jsonEncode(mediaUrls)) : const Value.absent(),
      needsSync: Value(needsSync),
    );

    await _database.into(_database.incidentReports).insertOnConflictUpdate(companion);
    final report = await (_database.select(_database.incidentReports)..where((tbl) => tbl.id.equals(data['id']))).getSingle();
    return report;
  }
}

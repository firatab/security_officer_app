import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/logger.dart';
import '../database/app_database.dart';
import '../models/patrol_tour_model.dart';

class PatrolTourRepository {
  final DioClient _dioClient;
  final AppDatabase _database;
  final _uuid = const Uuid();

  PatrolTourRepository(this._dioClient, this._database);

  // ============ FETCH OPERATIONS ============

  /// Fetch patrol tours for a site from API with offline fallback
  Future<List<PatrolTourModel>> fetchPatrolToursForSite(String siteId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.patrolTours,
        queryParameters: {'siteId': siteId, 'isActive': true},
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final toursData =
            (responseData?['data'] ?? responseData?['tours'] ?? []) as List;
        final tours = toursData
            .map((data) =>
                PatrolTourModel.fromJson(data as Map<String, dynamic>))
            .toList();

        // Save to local database
        await _savePatrolToursToDatabase(tours);
        return tours;
      } else {
        throw NetworkException(
            'Failed to fetch patrol tours: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      AppLogger.warning('Fetch patrol tours failed, falling back to local', e);
      // Fallback to local database
      return await getLocalPatrolToursForSite(siteId);
    } catch (e) {
      AppLogger.error('Unexpected error fetching patrol tours', e);
      // Fallback to local database
      return await getLocalPatrolToursForSite(siteId);
    }
  }

  /// Get patrol tours from local database
  Future<List<PatrolTourModel>> getLocalPatrolToursForSite(
      String siteId) async {
    final tours = await _database.patrolToursDao.getToursForSite(siteId);
    final result = <PatrolTourModel>[];

    for (final tour in tours) {
      final points = await _database.patrolToursDao.getPointsForTour(tour.id);
      final pointModels = <PatrolPointModel>[];

      for (final point in points) {
        final tasks =
            await _database.patrolToursDao.getTasksForPoint(point.id);
        pointModels.add(_patrolPointFromDb(point, tasks));
      }

      result.add(_patrolTourFromDb(tour, pointModels));
    }

    return result;
  }

  /// Fetch a single patrol tour with all details
  Future<PatrolTourModel?> fetchPatrolTourDetails(String tourId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.patrolTourDetails(tourId),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final tourData = responseData?['data'] as Map<String, dynamic>?;
        if (tourData != null) {
          final tour = PatrolTourModel.fromJson(tourData);
          await _savePatrolTourToDatabase(tour);
          return tour;
        }
      }
      return null;
    } on DioException catch (e) {
      AppLogger.warning('Fetch tour details failed, using local', e);
      return await getLocalPatrolTourDetails(tourId);
    } catch (e) {
      AppLogger.error('Unexpected error fetching tour details', e);
      return await getLocalPatrolTourDetails(tourId);
    }
  }

  /// Get patrol tour details from local database
  Future<PatrolTourModel?> getLocalPatrolTourDetails(String tourId) async {
    final tourData =
        await _database.patrolToursDao.getTourWithPointsAndTasks(tourId);
    if (tourData == null) return null;

    final tour = tourData['tour'] as PatrolTour;
    final pointsData = tourData['points'] as List<Map<String, dynamic>>;

    final pointModels = pointsData.map((pd) {
      final point = pd['point'] as PatrolTourPoint;
      final tasks = pd['tasks'] as List<PatrolTask>;
      return _patrolPointFromDb(point, tasks);
    }).toList();

    return _patrolTourFromDb(tour, pointModels);
  }

  // ============ PATROL INSTANCE OPERATIONS ============

  /// Start a new patrol instance
  Future<PatrolInstanceModel> startPatrolInstance({
    required String patrolTourId,
    required String employeeId,
    required String tenantId,
    String? shiftId,
    String? scheduleId,
    double? latitude,
    double? longitude,
  }) async {
    final instanceId = _uuid.v4();
    final now = DateTime.now();

    // Get tour to know total points
    final tour = await _database.patrolToursDao.getTourById(patrolTourId);
    final points = await _database.patrolToursDao.getPointsForTour(patrolTourId);
    final totalPoints = points.length;

    // Create local instance
    final instanceCompanion = PatrolInstancesCompanion.insert(
      id: instanceId,
      tenantId: tenantId,
      patrolTourId: patrolTourId,
      shiftId: drift.Value(shiftId),
      scheduleId: drift.Value(scheduleId),
      employeeId: employeeId,
      scheduledStart: drift.Value(now),
      actualStart: drift.Value(now),
      status: const drift.Value('in_progress'),
      totalPoints: drift.Value(totalPoints),
      completedPoints: const drift.Value(0),
      startLatitude: drift.Value(latitude),
      startLongitude: drift.Value(longitude),
      needsSync: const drift.Value(true),
      createdAt: now,
      updatedAt: now,
    );

    await _database.patrolInstancesDao.createInstance(instanceCompanion);

    // Create pending completions for all points
    for (final point in points) {
      final completionId = _uuid.v4();
      final completionCompanion = PatrolPointCompletionsCompanion.insert(
        id: completionId,
        tenantId: tenantId,
        patrolInstanceId: instanceId,
        patrolPointId: point.id,
        status: const drift.Value('pending'),
        needsSync: const drift.Value(true),
      );
      await _database.patrolInstancesDao.savePointCompletion(completionCompanion);
    }

    // Try to sync to server immediately
    await _syncPatrolInstanceStart(instanceId);

    return PatrolInstanceModel(
      id: instanceId,
      tenantId: tenantId,
      patrolTourId: patrolTourId,
      shiftId: shiftId,
      scheduleId: scheduleId,
      employeeId: employeeId,
      scheduledStart: now,
      actualStart: now,
      status: 'in_progress',
      totalPoints: totalPoints,
      completedPoints: 0,
      startLatitude: latitude,
      startLongitude: longitude,
      needsSync: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Complete a patrol point
  Future<PatrolPointCompletionModel> completePatrolPoint({
    required String instanceId,
    required String pointId,
    required String tenantId,
    required double latitude,
    required double longitude,
    bool scanVerified = false,
    String? scanMethod,
    String? photoLocalPath,
    String? notes,
    required List<Map<String, dynamic>> taskResponses,
  }) async {
    final now = DateTime.now();

    // Get point info for geofence check
    final point = await _database.patrolToursDao.getPointById(pointId);
    final withinGeofence = point != null
        ? _checkGeofence(
            latitude, longitude, point.latitude, point.longitude, point.geofenceRadius)
        : true;

    // Get existing completion
    final completions =
        await _database.patrolInstancesDao.getCompletionsForInstance(instanceId);
    final completion = completions.firstWhere(
      (c) => c.patrolPointId == pointId,
      orElse: () => throw AppException('Completion record not found'),
    );

    // Update completion
    final completionCompanion = PatrolPointCompletionsCompanion(
      id: drift.Value(completion.id),
      arrivedAt: drift.Value(completion.arrivedAt ?? now),
      completedAt: drift.Value(now),
      duration: drift.Value(completion.arrivedAt != null
          ? now.difference(completion.arrivedAt!).inSeconds
          : 0),
      scanVerified: drift.Value(scanVerified),
      scanMethod: drift.Value(scanMethod),
      latitude: drift.Value(latitude),
      longitude: drift.Value(longitude),
      withinGeofence: drift.Value(withinGeofence),
      photoLocalPath: drift.Value(photoLocalPath),
      notes: drift.Value(notes),
      status: const drift.Value('completed'),
      needsSync: const drift.Value(true),
    );

    await _database.patrolInstancesDao.savePointCompletion(completionCompanion);

    // Save task responses
    final taskResponseModels = <PatrolTaskResponseModel>[];
    for (final taskResponse in taskResponses) {
      final responseId = _uuid.v4();
      final responseCompanion = PatrolTaskResponsesCompanion.insert(
        id: responseId,
        tenantId: tenantId,
        pointCompletionId: completion.id,
        patrolTaskId: taskResponse['taskId'] as String,
        responseValue: drift.Value(taskResponse['value'] as String?),
        isCompleted: drift.Value(taskResponse['isCompleted'] as bool? ?? true),
        completedAt: drift.Value(now),
        needsSync: const drift.Value(true),
      );
      await _database.patrolInstancesDao.saveTaskResponse(responseCompanion);

      taskResponseModels.add(PatrolTaskResponseModel(
        id: responseId,
        tenantId: tenantId,
        pointCompletionId: completion.id,
        patrolTaskId: taskResponse['taskId'] as String,
        responseValue: taskResponse['value'] as String?,
        isCompleted: taskResponse['isCompleted'] as bool? ?? true,
        completedAt: now,
        needsSync: true,
      ));
    }

    // Increment completed points
    await _database.patrolInstancesDao.incrementCompletedPoints(instanceId);

    // Try to sync immediately
    await _syncPointCompletion(completion.id);

    return PatrolPointCompletionModel(
      id: completion.id,
      tenantId: tenantId,
      patrolInstanceId: instanceId,
      patrolPointId: pointId,
      arrivedAt: completion.arrivedAt ?? now,
      completedAt: now,
      duration: completion.arrivedAt != null
          ? now.difference(completion.arrivedAt!).inSeconds
          : 0,
      scanVerified: scanVerified,
      scanMethod: scanMethod,
      latitude: latitude,
      longitude: longitude,
      withinGeofence: withinGeofence,
      photoLocalPath: photoLocalPath,
      notes: notes,
      status: 'completed',
      needsSync: true,
      taskResponses: taskResponseModels,
    );
  }

  /// Mark arrival at a patrol point
  Future<void> markArrivalAtPoint({
    required String instanceId,
    required String pointId,
    required double latitude,
    required double longitude,
  }) async {
    final completions =
        await _database.patrolInstancesDao.getCompletionsForInstance(instanceId);
    final completion = completions.firstWhere(
      (c) => c.patrolPointId == pointId,
      orElse: () => throw AppException('Completion record not found'),
    );

    final completionCompanion = PatrolPointCompletionsCompanion(
      id: drift.Value(completion.id),
      arrivedAt: drift.Value(DateTime.now()),
      latitude: drift.Value(latitude),
      longitude: drift.Value(longitude),
      status: const drift.Value('arrived'),
      needsSync: const drift.Value(true),
    );

    await _database.patrolInstancesDao.savePointCompletion(completionCompanion);
  }

  /// Complete a patrol instance
  Future<void> completePatrolInstance(String instanceId, {String? notes}) async {
    await _database.patrolInstancesDao.completeInstance(instanceId, notes: notes);
    await _syncPatrolInstanceComplete(instanceId);
  }

  /// Abandon a patrol instance
  Future<void> abandonPatrolInstance(String instanceId, {String? reason}) async {
    await _database.patrolInstancesDao.abandonInstance(instanceId, reason: reason);
    await _syncPatrolInstanceComplete(instanceId);
  }

  /// Get active patrol instance for employee
  Future<PatrolInstanceModel?> getActivePatrolInstance(
      String employeeId) async {
    final instance = await _database.patrolInstancesDao.getActiveInstance(employeeId);
    if (instance == null) return null;

    return _patrolInstanceFromDb(instance);
  }

  /// Get patrol instance with all details
  Future<PatrolInstanceModel?> getPatrolInstanceDetails(
      String instanceId) async {
    final data =
        await _database.patrolInstancesDao.getInstanceWithCompletions(instanceId);
    if (data == null) return null;

    final instance = data['instance'] as PatrolInstance;
    final completionsData = data['completions'] as List<Map<String, dynamic>>;

    final completionModels = completionsData.map((cd) {
      final completion = cd['completion'] as PatrolPointCompletion;
      final responses = cd['taskResponses'] as List<PatrolTaskResponse>;
      return _pointCompletionFromDb(completion, responses);
    }).toList();

    return _patrolInstanceFromDb(instance, completionModels);
  }

  // ============ SYNC OPERATIONS ============

  /// Sync unsynced patrol instances to server
  Future<void> syncPatrolInstances() async {
    final unsyncedInstances =
        await _database.patrolInstancesDao.getUnsyncedInstances();

    for (final instance in unsyncedInstances) {
      try {
        if (instance.serverId == null) {
          // Create on server
          await _syncPatrolInstanceStart(instance.id);
        } else {
          // Update on server
          await _syncPatrolInstanceComplete(instance.id);
        }
      } catch (e) {
        AppLogger.error('Failed to sync patrol instance ${instance.id}', e);
      }
    }
  }

  /// Sync unsynced point completions
  Future<void> syncPointCompletions() async {
    final unsyncedCompletions =
        await _database.patrolInstancesDao.getUnsyncedCompletions();

    for (final completion in unsyncedCompletions) {
      try {
        await _syncPointCompletion(completion.id);
      } catch (e) {
        AppLogger.error(
            'Failed to sync point completion ${completion.id}', e);
      }
    }
  }

  // ============ PRIVATE METHODS ============

  Future<void> _savePatrolToursToDatabase(List<PatrolTourModel> tours) async {
    for (final tour in tours) {
      await _savePatrolTourToDatabase(tour);
    }
  }

  Future<void> _savePatrolTourToDatabase(PatrolTourModel tour) async {
    final tourCompanion = PatrolToursCompanion.insert(
      id: tour.id,
      tenantId: tour.tenantId,
      clientId: tour.clientId,
      siteId: tour.siteId,
      name: tour.name,
      description: drift.Value(tour.description),
      frequencyType: drift.Value(tour.frequencyType),
      intervalMinutes: drift.Value(tour.intervalMinutes),
      scheduledTimes: drift.Value(
          tour.scheduledTimes != null ? jsonEncode(tour.scheduledTimes) : null),
      startTime: drift.Value(tour.startTime),
      endTime: drift.Value(tour.endTime),
      sequenceRequired: drift.Value(tour.sequenceRequired),
      estimatedDuration: drift.Value(tour.estimatedDuration),
      isActive: drift.Value(tour.isActive),
      syncedAt: drift.Value(DateTime.now()),
    );

    final pointCompanions = <PatrolTourPointsCompanion>[];
    final tasksByPointId = <String, List<PatrolTasksCompanion>>{};

    if (tour.points != null) {
      for (final point in tour.points!) {
        pointCompanions.add(PatrolTourPointsCompanion.insert(
          id: point.id,
          tenantId: point.tenantId,
          patrolTourId: point.patrolTourId,
          checkpointId: point.checkpointId,
          sequenceNumber: drift.Value(point.sequenceNumber),
          requireScan: drift.Value(point.requireScan),
          requirePhoto: drift.Value(point.requirePhoto),
          requireNotes: drift.Value(point.requireNotes),
          instructions: drift.Value(point.instructions),
          expectedDuration: drift.Value(point.expectedDuration),
          isActive: drift.Value(point.isActive),
          checkpointName: point.checkpointName,
          checkpointCode: point.checkpointCode,
          latitude: drift.Value(point.latitude),
          longitude: drift.Value(point.longitude),
          geofenceRadius: drift.Value(point.geofenceRadius),
        ));

        if (point.tasks != null) {
          tasksByPointId[point.id] = point.tasks!
              .map((task) => PatrolTasksCompanion.insert(
                    id: task.id,
                    tenantId: task.tenantId,
                    patrolPointId: task.patrolPointId,
                    title: task.title,
                    description: drift.Value(task.description),
                    taskType: drift.Value(task.taskType),
                    options: drift.Value(
                        task.options != null ? jsonEncode(task.options) : null),
                    isRequired: drift.Value(task.isRequired),
                    sortOrder: drift.Value(task.sortOrder),
                    isActive: drift.Value(task.isActive),
                  ))
              .toList();
        }
      }
    }

    await _database.patrolToursDao.saveTourWithPointsAndTasks(
      tour: tourCompanion,
      points: pointCompanions,
      tasksByPointId: tasksByPointId,
    );
  }

  Future<void> _syncPatrolInstanceStart(String instanceId) async {
    try {
      final instance = await _database.patrolInstancesDao.getInstanceById(instanceId);
      if (instance == null) return;

      final response = await _dioClient.dio.post(
        ApiEndpoints.patrolInstances,
        data: {
          'patrolTourId': instance.patrolTourId,
          'shiftId': instance.shiftId,
          'scheduleId': instance.scheduleId,
          'startLatitude': instance.startLatitude,
          'startLongitude': instance.startLongitude,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>?;
        final serverId = data?['data']?['id'] as String?;
        await _database.patrolInstancesDao.markInstanceSynced(instanceId, serverId: serverId);
      }
    } on DioException catch (e) {
      AppLogger.warning('Failed to sync patrol instance start', e);
      // Will retry later via sync service
    }
  }

  Future<void> _syncPatrolInstanceComplete(String instanceId) async {
    try {
      final instance = await _database.patrolInstancesDao.getInstanceById(instanceId);
      if (instance == null || instance.serverId == null) return;

      await _dioClient.dio.patch(
        ApiEndpoints.patrolInstanceDetails(instance.serverId!),
        data: {
          'status': instance.status,
          'completedPoints': instance.completedPoints,
          'notes': instance.notes,
        },
      );

      await _database.patrolInstancesDao.markInstanceSynced(instanceId);
    } on DioException catch (e) {
      AppLogger.warning('Failed to sync patrol instance complete', e);
    }
  }

  Future<void> _syncPointCompletion(String completionId) async {
    try {
      final completions = await _database.patrolInstancesDao.getUnsyncedCompletions();
      final completion = completions.firstWhere(
        (c) => c.id == completionId,
        orElse: () => throw AppException('Completion not found'),
      );

      final instance =
          await _database.patrolInstancesDao.getInstanceById(completion.patrolInstanceId);
      if (instance?.serverId == null) return;

      final taskResponses =
          await _database.patrolInstancesDao.getTaskResponsesForCompletion(completionId);

      final response = await _dioClient.dio.post(
        ApiEndpoints.completePatrolPoint(instance!.serverId!, completion.patrolPointId),
        data: {
          'scanVerified': completion.scanVerified,
          'scanMethod': completion.scanMethod,
          'latitude': completion.latitude,
          'longitude': completion.longitude,
          'photoUrl': completion.photoUrl,
          'notes': completion.notes,
          'taskResponses': taskResponses
              .map((r) => {
                    'taskId': r.patrolTaskId,
                    'responseValue': r.responseValue,
                    'isCompleted': r.isCompleted,
                  })
              .toList(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>?;
        final serverId = data?['data']?['id'] as String?;
        await _database.patrolInstancesDao.markCompletionSynced(completionId, serverId: serverId);

        // Also mark task responses as synced
        for (final taskResponse in taskResponses) {
          await _database.patrolInstancesDao.markTaskResponseSynced(taskResponse.id);
        }
      }
    } on DioException catch (e) {
      AppLogger.warning('Failed to sync point completion', e);
    }
  }

  bool _checkGeofence(
    double currentLat,
    double currentLng,
    double? pointLat,
    double? pointLng,
    int radiusMeters,
  ) {
    if (pointLat == null || pointLng == null) return true;

    // Haversine formula
    const R = 6371e3; // Earth radius in meters
    final phi1 = currentLat * pi / 180;
    final phi2 = pointLat * pi / 180;
    final deltaPhi = (pointLat - currentLat) * pi / 180;
    final deltaLambda = (pointLng - currentLng) * pi / 180;

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final distance = R * c;

    return distance <= radiusMeters;
  }

  PatrolTourModel _patrolTourFromDb(PatrolTour tour,
      [List<PatrolPointModel>? points]) {
    List<String>? scheduledTimes;
    if (tour.scheduledTimes != null) {
      try {
        scheduledTimes = List<String>.from(jsonDecode(tour.scheduledTimes!));
      } catch (_) {}
    }

    return PatrolTourModel(
      id: tour.id,
      tenantId: tour.tenantId,
      clientId: tour.clientId,
      siteId: tour.siteId,
      name: tour.name,
      description: tour.description,
      frequencyType: tour.frequencyType,
      intervalMinutes: tour.intervalMinutes,
      scheduledTimes: scheduledTimes,
      startTime: tour.startTime,
      endTime: tour.endTime,
      sequenceRequired: tour.sequenceRequired,
      estimatedDuration: tour.estimatedDuration,
      isActive: tour.isActive,
      syncedAt: tour.syncedAt,
      points: points,
    );
  }

  PatrolPointModel _patrolPointFromDb(
      PatrolTourPoint point, List<PatrolTask> tasks) {
    return PatrolPointModel(
      id: point.id,
      tenantId: point.tenantId,
      patrolTourId: point.patrolTourId,
      checkpointId: point.checkpointId,
      sequenceNumber: point.sequenceNumber,
      requireScan: point.requireScan,
      requirePhoto: point.requirePhoto,
      requireNotes: point.requireNotes,
      instructions: point.instructions,
      expectedDuration: point.expectedDuration,
      isActive: point.isActive,
      checkpointName: point.checkpointName,
      checkpointCode: point.checkpointCode,
      latitude: point.latitude,
      longitude: point.longitude,
      geofenceRadius: point.geofenceRadius,
      tasks: tasks.map((t) => _patrolTaskFromDb(t)).toList(),
    );
  }

  PatrolTaskModel _patrolTaskFromDb(PatrolTask task) {
    List<String>? options;
    if (task.options != null) {
      try {
        options = List<String>.from(jsonDecode(task.options!));
      } catch (_) {}
    }

    return PatrolTaskModel(
      id: task.id,
      tenantId: task.tenantId,
      patrolPointId: task.patrolPointId,
      title: task.title,
      description: task.description,
      taskType: task.taskType,
      options: options,
      isRequired: task.isRequired,
      sortOrder: task.sortOrder,
      isActive: task.isActive,
    );
  }

  PatrolInstanceModel _patrolInstanceFromDb(PatrolInstance instance,
      [List<PatrolPointCompletionModel>? completions]) {
    return PatrolInstanceModel(
      id: instance.id,
      serverId: instance.serverId,
      tenantId: instance.tenantId,
      patrolTourId: instance.patrolTourId,
      scheduleId: instance.scheduleId,
      shiftId: instance.shiftId,
      employeeId: instance.employeeId,
      scheduledStart: instance.scheduledStart,
      actualStart: instance.actualStart,
      actualEnd: instance.actualEnd,
      status: instance.status,
      totalPoints: instance.totalPoints,
      completedPoints: instance.completedPoints,
      startLatitude: instance.startLatitude,
      startLongitude: instance.startLongitude,
      notes: instance.notes,
      needsSync: instance.needsSync,
      syncedAt: instance.syncedAt,
      createdAt: instance.createdAt,
      updatedAt: instance.updatedAt,
      pointCompletions: completions,
    );
  }

  PatrolPointCompletionModel _pointCompletionFromDb(
      PatrolPointCompletion completion, List<PatrolTaskResponse> responses) {
    return PatrolPointCompletionModel(
      id: completion.id,
      serverId: completion.serverId,
      tenantId: completion.tenantId,
      patrolInstanceId: completion.patrolInstanceId,
      patrolPointId: completion.patrolPointId,
      arrivedAt: completion.arrivedAt,
      completedAt: completion.completedAt,
      duration: completion.duration,
      scanVerified: completion.scanVerified,
      scanMethod: completion.scanMethod,
      latitude: completion.latitude,
      longitude: completion.longitude,
      withinGeofence: completion.withinGeofence,
      photoLocalPath: completion.photoLocalPath,
      photoUrl: completion.photoUrl,
      notes: completion.notes,
      status: completion.status,
      needsSync: completion.needsSync,
      syncedAt: completion.syncedAt,
      taskResponses: responses.map((r) => _taskResponseFromDb(r)).toList(),
    );
  }

  PatrolTaskResponseModel _taskResponseFromDb(PatrolTaskResponse response) {
    return PatrolTaskResponseModel(
      id: response.id,
      serverId: response.serverId,
      tenantId: response.tenantId,
      pointCompletionId: response.pointCompletionId,
      patrolTaskId: response.patrolTaskId,
      responseValue: response.responseValue,
      isCompleted: response.isCompleted,
      completedAt: response.completedAt,
      needsSync: response.needsSync,
      syncedAt: response.syncedAt,
    );
  }
}

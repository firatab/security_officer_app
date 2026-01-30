// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patrol_tour_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckpointInfo _$CheckpointInfoFromJson(Map json) =>
    $checkedCreate('CheckpointInfo', json, ($checkedConvert) {
      final val = CheckpointInfo(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String),
        latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
        longitude: $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$CheckpointInfoToJson(CheckpointInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

PatrolTaskModel _$PatrolTaskModelFromJson(Map json) => $checkedCreate(
  'PatrolTaskModel',
  json,
  ($checkedConvert) {
    final val = PatrolTaskModel(
      id: $checkedConvert('id', (v) => v as String),
      tenantId: $checkedConvert('tenantId', (v) => v as String),
      patrolPointId: $checkedConvert('patrolPointId', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String),
      description: $checkedConvert('description', (v) => v as String?),
      taskType: $checkedConvert('taskType', (v) => v as String),
      options: $checkedConvert(
        'options',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      isRequired: $checkedConvert('isRequired', (v) => v as bool? ?? true),
      sortOrder: $checkedConvert('sortOrder', (v) => (v as num?)?.toInt() ?? 0),
      isActive: $checkedConvert('isActive', (v) => v as bool? ?? true),
    );
    return val;
  },
);

Map<String, dynamic> _$PatrolTaskModelToJson(PatrolTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'patrolPointId': instance.patrolPointId,
      'title': instance.title,
      'description': instance.description,
      'taskType': instance.taskType,
      'options': instance.options,
      'isRequired': instance.isRequired,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
    };

PatrolPointModel _$PatrolPointModelFromJson(Map json) => $checkedCreate(
  'PatrolPointModel',
  json,
  ($checkedConvert) {
    final val = PatrolPointModel(
      id: $checkedConvert('id', (v) => v as String),
      tenantId: $checkedConvert('tenantId', (v) => v as String),
      patrolTourId: $checkedConvert('patrolTourId', (v) => v as String),
      checkpointId: $checkedConvert('checkpointId', (v) => v as String),
      sequenceNumber: $checkedConvert(
        'sequenceNumber',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      requireScan: $checkedConvert('requireScan', (v) => v as bool? ?? true),
      requirePhoto: $checkedConvert('requirePhoto', (v) => v as bool? ?? false),
      requireNotes: $checkedConvert('requireNotes', (v) => v as bool? ?? false),
      instructions: $checkedConvert('instructions', (v) => v as String?),
      expectedDuration: $checkedConvert(
        'expectedDuration',
        (v) => (v as num?)?.toInt() ?? 5,
      ),
      isActive: $checkedConvert('isActive', (v) => v as bool? ?? true),
      checkpointName: $checkedConvert('checkpointName', (v) => v as String),
      checkpointCode: $checkedConvert('checkpointCode', (v) => v as String),
      latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
      longitude: $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
      geofenceRadius: $checkedConvert(
        'geofenceRadius',
        (v) => (v as num?)?.toInt() ?? 50,
      ),
      tasks: $checkedConvert(
        'tasks',
        (v) => (v as List<dynamic>?)
            ?.map(
              (e) =>
                  PatrolTaskModel.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$PatrolPointModelToJson(PatrolPointModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'patrolTourId': instance.patrolTourId,
      'checkpointId': instance.checkpointId,
      'sequenceNumber': instance.sequenceNumber,
      'requireScan': instance.requireScan,
      'requirePhoto': instance.requirePhoto,
      'requireNotes': instance.requireNotes,
      'instructions': instance.instructions,
      'expectedDuration': instance.expectedDuration,
      'isActive': instance.isActive,
      'checkpointName': instance.checkpointName,
      'checkpointCode': instance.checkpointCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'geofenceRadius': instance.geofenceRadius,
      'tasks': instance.tasks?.map((e) => e.toJson()).toList(),
    };

PatrolTourModel _$PatrolTourModelFromJson(Map json) =>
    $checkedCreate('PatrolTourModel', json, ($checkedConvert) {
      final val = PatrolTourModel(
        id: $checkedConvert('id', (v) => v as String),
        tenantId: $checkedConvert('tenantId', (v) => v as String),
        clientId: $checkedConvert('clientId', (v) => v as String),
        siteId: $checkedConvert('siteId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String?),
        frequencyType: $checkedConvert(
          'frequencyType',
          (v) => v as String? ?? 'per_shift',
        ),
        intervalMinutes: $checkedConvert(
          'intervalMinutes',
          (v) => (v as num?)?.toInt(),
        ),
        scheduledTimes: $checkedConvert(
          'scheduledTimes',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        startTime: $checkedConvert('startTime', (v) => v as String?),
        endTime: $checkedConvert('endTime', (v) => v as String?),
        sequenceRequired: $checkedConvert(
          'sequenceRequired',
          (v) => v as bool? ?? false,
        ),
        estimatedDuration: $checkedConvert(
          'estimatedDuration',
          (v) => (v as num?)?.toInt(),
        ),
        isActive: $checkedConvert('isActive', (v) => v as bool? ?? true),
        syncedAt: $checkedConvert(
          'syncedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        clientName: $checkedConvert('clientName', (v) => v as String?),
        siteName: $checkedConvert('siteName', (v) => v as String?),
        points: $checkedConvert(
          'points',
          (v) => (v as List<dynamic>?)
              ?.map(
                (e) => PatrolPointModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PatrolTourModelToJson(PatrolTourModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'clientId': instance.clientId,
      'siteId': instance.siteId,
      'name': instance.name,
      'description': instance.description,
      'frequencyType': instance.frequencyType,
      'intervalMinutes': instance.intervalMinutes,
      'scheduledTimes': instance.scheduledTimes,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'sequenceRequired': instance.sequenceRequired,
      'estimatedDuration': instance.estimatedDuration,
      'isActive': instance.isActive,
      'syncedAt': instance.syncedAt?.toIso8601String(),
      'clientName': instance.clientName,
      'siteName': instance.siteName,
      'points': instance.points?.map((e) => e.toJson()).toList(),
    };

PatrolTaskResponseModel _$PatrolTaskResponseModelFromJson(Map json) =>
    $checkedCreate('PatrolTaskResponseModel', json, ($checkedConvert) {
      final val = PatrolTaskResponseModel(
        id: $checkedConvert('id', (v) => v as String),
        serverId: $checkedConvert('serverId', (v) => v as String?),
        tenantId: $checkedConvert('tenantId', (v) => v as String),
        pointCompletionId: $checkedConvert(
          'pointCompletionId',
          (v) => v as String,
        ),
        patrolTaskId: $checkedConvert('patrolTaskId', (v) => v as String),
        responseValue: $checkedConvert('responseValue', (v) => v as String?),
        isCompleted: $checkedConvert('isCompleted', (v) => v as bool? ?? false),
        completedAt: $checkedConvert(
          'completedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        needsSync: $checkedConvert('needsSync', (v) => v as bool? ?? false),
        syncedAt: $checkedConvert(
          'syncedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PatrolTaskResponseModelToJson(
  PatrolTaskResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'serverId': instance.serverId,
  'tenantId': instance.tenantId,
  'pointCompletionId': instance.pointCompletionId,
  'patrolTaskId': instance.patrolTaskId,
  'responseValue': instance.responseValue,
  'isCompleted': instance.isCompleted,
  'completedAt': instance.completedAt?.toIso8601String(),
  'needsSync': instance.needsSync,
  'syncedAt': instance.syncedAt?.toIso8601String(),
};

PatrolPointCompletionModel _$PatrolPointCompletionModelFromJson(
  Map json,
) => $checkedCreate('PatrolPointCompletionModel', json, ($checkedConvert) {
  final val = PatrolPointCompletionModel(
    id: $checkedConvert('id', (v) => v as String),
    serverId: $checkedConvert('serverId', (v) => v as String?),
    tenantId: $checkedConvert('tenantId', (v) => v as String),
    patrolInstanceId: $checkedConvert('patrolInstanceId', (v) => v as String),
    patrolPointId: $checkedConvert('patrolPointId', (v) => v as String),
    arrivedAt: $checkedConvert(
      'arrivedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    completedAt: $checkedConvert(
      'completedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    duration: $checkedConvert('duration', (v) => (v as num?)?.toInt()),
    scanVerified: $checkedConvert('scanVerified', (v) => v as bool? ?? false),
    scanMethod: $checkedConvert('scanMethod', (v) => v as String?),
    latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
    longitude: $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
    withinGeofence: $checkedConvert(
      'withinGeofence',
      (v) => v as bool? ?? true,
    ),
    photoLocalPath: $checkedConvert('photoLocalPath', (v) => v as String?),
    photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
    notes: $checkedConvert('notes', (v) => v as String?),
    status: $checkedConvert('status', (v) => v as String? ?? 'pending'),
    needsSync: $checkedConvert('needsSync', (v) => v as bool? ?? false),
    syncedAt: $checkedConvert(
      'syncedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    taskResponses: $checkedConvert(
      'taskResponses',
      (v) => (v as List<dynamic>?)
          ?.map(
            (e) => PatrolTaskResponseModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$PatrolPointCompletionModelToJson(
  PatrolPointCompletionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'serverId': instance.serverId,
  'tenantId': instance.tenantId,
  'patrolInstanceId': instance.patrolInstanceId,
  'patrolPointId': instance.patrolPointId,
  'arrivedAt': instance.arrivedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'duration': instance.duration,
  'scanVerified': instance.scanVerified,
  'scanMethod': instance.scanMethod,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'withinGeofence': instance.withinGeofence,
  'photoLocalPath': instance.photoLocalPath,
  'photoUrl': instance.photoUrl,
  'notes': instance.notes,
  'status': instance.status,
  'needsSync': instance.needsSync,
  'syncedAt': instance.syncedAt?.toIso8601String(),
  'taskResponses': instance.taskResponses?.map((e) => e.toJson()).toList(),
};

PatrolInstanceModel _$PatrolInstanceModelFromJson(
  Map json,
) => $checkedCreate('PatrolInstanceModel', json, ($checkedConvert) {
  final val = PatrolInstanceModel(
    id: $checkedConvert('id', (v) => v as String),
    serverId: $checkedConvert('serverId', (v) => v as String?),
    tenantId: $checkedConvert('tenantId', (v) => v as String),
    patrolTourId: $checkedConvert('patrolTourId', (v) => v as String),
    scheduleId: $checkedConvert('scheduleId', (v) => v as String?),
    shiftId: $checkedConvert('shiftId', (v) => v as String?),
    employeeId: $checkedConvert('employeeId', (v) => v as String),
    scheduledStart: $checkedConvert(
      'scheduledStart',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    actualStart: $checkedConvert(
      'actualStart',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    actualEnd: $checkedConvert(
      'actualEnd',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    status: $checkedConvert('status', (v) => v as String? ?? 'pending'),
    totalPoints: $checkedConvert(
      'totalPoints',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    completedPoints: $checkedConvert(
      'completedPoints',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    startLatitude: $checkedConvert(
      'startLatitude',
      (v) => (v as num?)?.toDouble(),
    ),
    startLongitude: $checkedConvert(
      'startLongitude',
      (v) => (v as num?)?.toDouble(),
    ),
    notes: $checkedConvert('notes', (v) => v as String?),
    needsSync: $checkedConvert('needsSync', (v) => v as bool? ?? false),
    syncedAt: $checkedConvert(
      'syncedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    patrolTour: $checkedConvert(
      'patrolTour',
      (v) => v == null
          ? null
          : PatrolTourModel.fromJson(Map<String, dynamic>.from(v as Map)),
    ),
    pointCompletions: $checkedConvert(
      'pointCompletions',
      (v) => (v as List<dynamic>?)
          ?.map(
            (e) => PatrolPointCompletionModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$PatrolInstanceModelToJson(
  PatrolInstanceModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'serverId': instance.serverId,
  'tenantId': instance.tenantId,
  'patrolTourId': instance.patrolTourId,
  'scheduleId': instance.scheduleId,
  'shiftId': instance.shiftId,
  'employeeId': instance.employeeId,
  'scheduledStart': instance.scheduledStart?.toIso8601String(),
  'actualStart': instance.actualStart?.toIso8601String(),
  'actualEnd': instance.actualEnd?.toIso8601String(),
  'status': instance.status,
  'totalPoints': instance.totalPoints,
  'completedPoints': instance.completedPoints,
  'startLatitude': instance.startLatitude,
  'startLongitude': instance.startLongitude,
  'notes': instance.notes,
  'needsSync': instance.needsSync,
  'syncedAt': instance.syncedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'patrolTour': instance.patrolTour?.toJson(),
  'pointCompletions': instance.pointCompletions
      ?.map((e) => e.toJson())
      .toList(),
};

PatrolScheduleModel _$PatrolScheduleModelFromJson(Map json) =>
    $checkedCreate('PatrolScheduleModel', json, ($checkedConvert) {
      final val = PatrolScheduleModel(
        id: $checkedConvert('id', (v) => v as String),
        tenantId: $checkedConvert('tenantId', (v) => v as String),
        patrolTourId: $checkedConvert('patrolTourId', (v) => v as String),
        shiftId: $checkedConvert('shiftId', (v) => v as String?),
        employeeId: $checkedConvert('employeeId', (v) => v as String?),
        scheduledDate: $checkedConvert(
          'scheduledDate',
          (v) => DateTime.parse(v as String),
        ),
        scheduledTime: $checkedConvert('scheduledTime', (v) => v as String?),
        status: $checkedConvert('status', (v) => v as String? ?? 'pending'),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        patrolTour: $checkedConvert(
          'patrolTour',
          (v) => v == null
              ? null
              : PatrolTourModel.fromJson(Map<String, dynamic>.from(v as Map)),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PatrolScheduleModelToJson(
  PatrolScheduleModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'tenantId': instance.tenantId,
  'patrolTourId': instance.patrolTourId,
  'shiftId': instance.shiftId,
  'employeeId': instance.employeeId,
  'scheduledDate': instance.scheduledDate.toIso8601String(),
  'scheduledTime': instance.scheduledTime,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'patrolTour': instance.patrolTour?.toJson(),
};

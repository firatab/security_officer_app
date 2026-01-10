import 'package:json_annotation/json_annotation.dart';

part 'patrol_tour_model.g.dart';

/// Patrol tour frequency types
enum PatrolFrequencyType {
  @JsonValue('per_shift')
  perShift,
  @JsonValue('fixed_interval')
  fixedInterval,
  @JsonValue('specific_times')
  specificTimes,
}

/// Task types available for patrol points
enum PatrolTaskType {
  checkbox,
  text,
  number,
  select,
  photo,
}

/// Patrol tour status
enum PatrolInstanceStatus {
  pending,
  @JsonValue('in_progress')
  inProgress,
  completed,
  incomplete,
  abandoned,
}

/// Point completion status
enum PointCompletionStatus {
  pending,
  arrived,
  completed,
  skipped,
}

/// Checkpoint info for offline use (denormalized)
@JsonSerializable()
class CheckpointInfo {
  final String id;
  final String name;
  final String code;
  final double? latitude;
  final double? longitude;

  CheckpointInfo({
    required this.id,
    required this.name,
    required this.code,
    this.latitude,
    this.longitude,
  });

  factory CheckpointInfo.fromJson(Map<String, dynamic> json) =>
      _$CheckpointInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpointInfoToJson(this);
}

/// Patrol task definition
@JsonSerializable()
class PatrolTaskModel {
  final String id;
  final String tenantId;
  final String patrolPointId;
  final String title;
  final String? description;
  final String taskType;
  final List<String>? options;
  final bool isRequired;
  final int sortOrder;
  final bool isActive;

  PatrolTaskModel({
    required this.id,
    required this.tenantId,
    required this.patrolPointId,
    required this.title,
    this.description,
    required this.taskType,
    this.options,
    this.isRequired = true,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory PatrolTaskModel.fromJson(Map<String, dynamic> json) =>
      _$PatrolTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolTaskModelToJson(this);

  PatrolTaskType get taskTypeEnum {
    switch (taskType) {
      case 'checkbox':
        return PatrolTaskType.checkbox;
      case 'text':
        return PatrolTaskType.text;
      case 'number':
        return PatrolTaskType.number;
      case 'select':
        return PatrolTaskType.select;
      case 'photo':
        return PatrolTaskType.photo;
      default:
        return PatrolTaskType.checkbox;
    }
  }
}

/// Patrol point (checkpoint within a tour)
@JsonSerializable()
class PatrolPointModel {
  final String id;
  final String tenantId;
  final String patrolTourId;
  final String checkpointId;
  final int sequenceNumber;
  final bool requireScan;
  final bool requirePhoto;
  final bool requireNotes;
  final String? instructions;
  final int expectedDuration;
  final bool isActive;
  // Denormalized checkpoint info
  final String checkpointName;
  final String checkpointCode;
  final double? latitude;
  final double? longitude;
  final int geofenceRadius;
  // Tasks for this point
  final List<PatrolTaskModel>? tasks;

  PatrolPointModel({
    required this.id,
    required this.tenantId,
    required this.patrolTourId,
    required this.checkpointId,
    this.sequenceNumber = 0,
    this.requireScan = true,
    this.requirePhoto = false,
    this.requireNotes = false,
    this.instructions,
    this.expectedDuration = 5,
    this.isActive = true,
    required this.checkpointName,
    required this.checkpointCode,
    this.latitude,
    this.longitude,
    this.geofenceRadius = 50,
    this.tasks,
  });

  factory PatrolPointModel.fromJson(Map<String, dynamic> json) =>
      _$PatrolPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolPointModelToJson(this);

  bool get hasGeofence => latitude != null && longitude != null;
}

/// Patrol tour model (the template)
@JsonSerializable()
class PatrolTourModel {
  final String id;
  final String tenantId;
  final String clientId;
  final String siteId;
  final String name;
  final String? description;
  final String frequencyType;
  final int? intervalMinutes;
  final List<String>? scheduledTimes;
  final String? startTime;
  final String? endTime;
  final bool sequenceRequired;
  final int? estimatedDuration;
  final bool isActive;
  final DateTime? syncedAt;
  // Client and site info
  final String? clientName;
  final String? siteName;
  // Points in this tour
  final List<PatrolPointModel>? points;

  PatrolTourModel({
    required this.id,
    required this.tenantId,
    required this.clientId,
    required this.siteId,
    required this.name,
    this.description,
    this.frequencyType = 'per_shift',
    this.intervalMinutes,
    this.scheduledTimes,
    this.startTime,
    this.endTime,
    this.sequenceRequired = false,
    this.estimatedDuration,
    this.isActive = true,
    this.syncedAt,
    this.clientName,
    this.siteName,
    this.points,
  });

  factory PatrolTourModel.fromJson(Map<String, dynamic> json) =>
      _$PatrolTourModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolTourModelToJson(this);

  PatrolFrequencyType get frequencyTypeEnum {
    switch (frequencyType) {
      case 'per_shift':
        return PatrolFrequencyType.perShift;
      case 'fixed_interval':
        return PatrolFrequencyType.fixedInterval;
      case 'specific_times':
        return PatrolFrequencyType.specificTimes;
      default:
        return PatrolFrequencyType.perShift;
    }
  }

  int get totalPoints => points?.length ?? 0;

  String get frequencyDescription {
    switch (frequencyType) {
      case 'per_shift':
        return 'Once per shift';
      case 'fixed_interval':
        return 'Every ${intervalMinutes ?? 60} minutes';
      case 'specific_times':
        if (scheduledTimes != null && scheduledTimes!.isNotEmpty) {
          return 'At ${scheduledTimes!.join(", ")}';
        }
        return 'Specific times';
      default:
        return 'Unknown';
    }
  }
}

/// Task response for a completed task
@JsonSerializable()
class PatrolTaskResponseModel {
  final String id;
  final String? serverId;
  final String tenantId;
  final String pointCompletionId;
  final String patrolTaskId;
  final String? responseValue;
  final bool isCompleted;
  final DateTime? completedAt;
  final bool needsSync;
  final DateTime? syncedAt;

  PatrolTaskResponseModel({
    required this.id,
    this.serverId,
    required this.tenantId,
    required this.pointCompletionId,
    required this.patrolTaskId,
    this.responseValue,
    this.isCompleted = false,
    this.completedAt,
    this.needsSync = false,
    this.syncedAt,
  });

  factory PatrolTaskResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PatrolTaskResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolTaskResponseModelToJson(this);
}

/// Point completion record
@JsonSerializable()
class PatrolPointCompletionModel {
  final String id;
  final String? serverId;
  final String tenantId;
  final String patrolInstanceId;
  final String patrolPointId;
  final DateTime? arrivedAt;
  final DateTime? completedAt;
  final int? duration;
  final bool scanVerified;
  final String? scanMethod;
  final double? latitude;
  final double? longitude;
  final bool withinGeofence;
  final String? photoLocalPath;
  final String? photoUrl;
  final String? notes;
  final String status;
  final bool needsSync;
  final DateTime? syncedAt;
  // Task responses for this completion
  final List<PatrolTaskResponseModel>? taskResponses;

  PatrolPointCompletionModel({
    required this.id,
    this.serverId,
    required this.tenantId,
    required this.patrolInstanceId,
    required this.patrolPointId,
    this.arrivedAt,
    this.completedAt,
    this.duration,
    this.scanVerified = false,
    this.scanMethod,
    this.latitude,
    this.longitude,
    this.withinGeofence = true,
    this.photoLocalPath,
    this.photoUrl,
    this.notes,
    this.status = 'pending',
    this.needsSync = false,
    this.syncedAt,
    this.taskResponses,
  });

  factory PatrolPointCompletionModel.fromJson(Map<String, dynamic> json) =>
      _$PatrolPointCompletionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolPointCompletionModelToJson(this);

  PointCompletionStatus get statusEnum {
    switch (status) {
      case 'pending':
        return PointCompletionStatus.pending;
      case 'arrived':
        return PointCompletionStatus.arrived;
      case 'completed':
        return PointCompletionStatus.completed;
      case 'skipped':
        return PointCompletionStatus.skipped;
      default:
        return PointCompletionStatus.pending;
    }
  }
}

/// Patrol instance (an execution of a tour)
@JsonSerializable()
class PatrolInstanceModel {
  final String id;
  final String? serverId;
  final String tenantId;
  final String patrolTourId;
  final String? scheduleId;
  final String? shiftId;
  final String employeeId;
  final DateTime? scheduledStart;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final String status;
  final int totalPoints;
  final int completedPoints;
  final double? startLatitude;
  final double? startLongitude;
  final String? notes;
  final bool needsSync;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Related tour info
  final PatrolTourModel? patrolTour;
  // Point completions
  final List<PatrolPointCompletionModel>? pointCompletions;

  PatrolInstanceModel({
    required this.id,
    this.serverId,
    required this.tenantId,
    required this.patrolTourId,
    this.scheduleId,
    this.shiftId,
    required this.employeeId,
    this.scheduledStart,
    this.actualStart,
    this.actualEnd,
    this.status = 'pending',
    this.totalPoints = 0,
    this.completedPoints = 0,
    this.startLatitude,
    this.startLongitude,
    this.notes,
    this.needsSync = false,
    this.syncedAt,
    required this.createdAt,
    required this.updatedAt,
    this.patrolTour,
    this.pointCompletions,
  });

  factory PatrolInstanceModel.fromJson(Map<String, dynamic> json) =>
      _$PatrolInstanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolInstanceModelToJson(this);

  PatrolInstanceStatus get statusEnum {
    switch (status) {
      case 'pending':
        return PatrolInstanceStatus.pending;
      case 'in_progress':
        return PatrolInstanceStatus.inProgress;
      case 'completed':
        return PatrolInstanceStatus.completed;
      case 'incomplete':
        return PatrolInstanceStatus.incomplete;
      case 'abandoned':
        return PatrolInstanceStatus.abandoned;
      default:
        return PatrolInstanceStatus.pending;
    }
  }

  double get progressPercentage {
    if (totalPoints == 0) return 0.0;
    return (completedPoints / totalPoints) * 100;
  }

  bool get isComplete => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';
}

/// Patrol schedule (planned patrol instances)
@JsonSerializable()
class PatrolScheduleModel {
  final String id;
  final String tenantId;
  final String patrolTourId;
  final String? shiftId;
  final String? employeeId;
  final DateTime scheduledDate;
  final String? scheduledTime;
  final String status;
  final DateTime createdAt;
  // Related tour
  final PatrolTourModel? patrolTour;

  PatrolScheduleModel({
    required this.id,
    required this.tenantId,
    required this.patrolTourId,
    this.shiftId,
    this.employeeId,
    required this.scheduledDate,
    this.scheduledTime,
    this.status = 'pending',
    required this.createdAt,
    this.patrolTour,
  });

  factory PatrolScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$PatrolScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolScheduleModelToJson(this);
}

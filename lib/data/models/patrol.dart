import 'package:json_annotation/json_annotation.dart';

part 'patrol.g.dart';

/// Helper function to parse double from string or number (for Prisma Decimal fields)
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@JsonSerializable()
class Patrol {
  final String id;
  final String siteId;
  final String name;
  final String? description;
  final List<Checkpoint> checkpoints;

  Patrol({
    required this.id,
    required this.siteId,
    required this.name,
    this.description,
    required this.checkpoints,
  });

  factory Patrol.fromJson(Map<String, dynamic> json) => _$PatrolFromJson(json);

  Map<String, dynamic> toJson() => _$PatrolToJson(this);

  Patrol copyWith({
    String? id,
    String? siteId,
    String? name,
    String? description,
    List<Checkpoint>? checkpoints,
  }) {
    return Patrol(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      name: name ?? this.name,
      description: description ?? this.description,
      checkpoints: checkpoints ?? this.checkpoints,
    );
  }
}

@JsonSerializable()
class Checkpoint {
  final String id;
  final String name;
  final String? instructions;
  @JsonKey(fromJson: _parseDouble)
  final double? latitude;
  @JsonKey(fromJson: _parseDouble)
  final double? longitude;
  final String? qrCode;
  @JsonKey(defaultValue: false)
  final bool completed;
  final DateTime? completedAt;

  Checkpoint({
    required this.id,
    required this.name,
    this.instructions,
    this.latitude,
    this.longitude,
    this.qrCode,
    this.completed = false,
    this.completedAt,
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) => _$CheckpointFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpointToJson(this);

  Checkpoint copyWith({
    String? id,
    String? name,
    String? instructions,
    double? latitude,
    double? longitude,
    String? qrCode,
    bool? completed,
    DateTime? completedAt,
  }) {
    return Checkpoint(
      id: id ?? this.id,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      qrCode: qrCode ?? this.qrCode,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

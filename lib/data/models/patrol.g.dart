// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patrol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patrol _$PatrolFromJson(Map json) => $checkedCreate('Patrol', json, (
  $checkedConvert,
) {
  final val = Patrol(
    id: $checkedConvert('id', (v) => v as String),
    siteId: $checkedConvert('siteId', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String?),
    checkpoints: $checkedConvert(
      'checkpoints',
      (v) => (v as List<dynamic>)
          .map((e) => Checkpoint.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$PatrolToJson(Patrol instance) => <String, dynamic>{
  'id': instance.id,
  'siteId': instance.siteId,
  'name': instance.name,
  'description': instance.description,
  'checkpoints': instance.checkpoints.map((e) => e.toJson()).toList(),
};

Checkpoint _$CheckpointFromJson(Map json) =>
    $checkedCreate('Checkpoint', json, ($checkedConvert) {
      final val = Checkpoint(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        instructions: $checkedConvert('instructions', (v) => v as String?),
        latitude: $checkedConvert('latitude', (v) => _parseDouble(v)),
        longitude: $checkedConvert('longitude', (v) => _parseDouble(v)),
        qrCode: $checkedConvert('qrCode', (v) => v as String?),
        completed: $checkedConvert('completed', (v) => v as bool? ?? false),
        completedAt: $checkedConvert(
          'completedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CheckpointToJson(Checkpoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'instructions': instance.instructions,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'qrCode': instance.qrCode,
      'completed': instance.completed,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

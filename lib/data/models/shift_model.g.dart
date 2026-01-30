// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(
  Map json,
) => $checkedCreate('ShiftModel', json, ($checkedConvert) {
  final val = ShiftModel(
    id: $checkedConvert('id', (v) => v as String),
    tenantId: $checkedConvert('tenantId', (v) => v as String?),
    employeeId: $checkedConvert('employeeId', (v) => v as String?),
    siteId: $checkedConvert('siteId', (v) => v as String),
    clientId: $checkedConvert('clientId', (v) => v as String?),
    site: $checkedConvert(
      'site',
      (v) => SiteModel.fromJson(Map<String, dynamic>.from(v as Map)),
    ),
    client: $checkedConvert(
      'client',
      (v) => v == null
          ? null
          : ClientModel.fromJson(Map<String, dynamic>.from(v as Map)),
    ),
    shiftDate: $checkedConvert('shiftDate', (v) => DateTime.parse(v as String)),
    startTime: $checkedConvert('startTime', (v) => DateTime.parse(v as String)),
    endTime: $checkedConvert('endTime', (v) => DateTime.parse(v as String)),
    breakMinutes: $checkedConvert(
      'breakMinutes',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    status: $checkedConvert('status', (v) => v as String),
    shiftType: $checkedConvert('shiftType', (v) => v as String?),
    notes: $checkedConvert('notes', (v) => v as String?),
    checkCallRequired: $checkedConvert('checkCallRequired', (v) => v as bool?),
    attendance: $checkedConvert(
      'attendance',
      (v) => v == null
          ? null
          : AttendanceModel.fromJson(Map<String, dynamic>.from(v as Map)),
    ),
  );
  return val;
});

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'employeeId': instance.employeeId,
      'siteId': instance.siteId,
      'clientId': instance.clientId,
      'site': instance.site.toJson(),
      'client': instance.client?.toJson(),
      'shiftDate': instance.shiftDate.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'breakMinutes': instance.breakMinutes,
      'status': instance.status,
      'shiftType': instance.shiftType,
      'notes': instance.notes,
      'checkCallRequired': instance.checkCallRequired,
      'attendance': instance.attendance?.toJson(),
    };

SiteModel _$SiteModelFromJson(Map json) =>
    $checkedCreate('SiteModel', json, ($checkedConvert) {
      final val = SiteModel(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        address: $checkedConvert('address', (v) => v as String? ?? ''),
        latitude: $checkedConvert('latitude', (v) => _parseDouble(v)),
        longitude: $checkedConvert('longitude', (v) => _parseDouble(v)),
        checkCallEnabled: $checkedConvert(
          'checkCallEnabled',
          (v) => v as bool? ?? false,
        ),
        checkCallFrequency: $checkedConvert(
          'checkCallFrequency',
          (v) => _parseInt(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SiteModelToJson(SiteModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'checkCallEnabled': instance.checkCallEnabled,
  'checkCallFrequency': instance.checkCallFrequency,
};

ClientModel _$ClientModelFromJson(Map json) =>
    $checkedCreate('ClientModel', json, ($checkedConvert) {
      final val = ClientModel(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ClientModelToJson(ClientModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

AttendanceModel _$AttendanceModelFromJson(Map json) =>
    $checkedCreate('AttendanceModel', json, ($checkedConvert) {
      final val = AttendanceModel(
        id: $checkedConvert('id', (v) => v as String),
        bookOnTime: $checkedConvert(
          'bookOnTime',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        bookOffTime: $checkedConvert(
          'bookOffTime',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        status: $checkedConvert('status', (v) => v as String),
        totalHours: $checkedConvert('totalHours', (v) => _parseDouble(v)),
        isLate: $checkedConvert('isLate', (v) => v as bool),
        lateMinutes: $checkedConvert('lateMinutes', (v) => _parseInt(v)),
        autoBookedOff: $checkedConvert('autoBookedOff', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$AttendanceModelToJson(AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookOnTime': instance.bookOnTime?.toIso8601String(),
      'bookOffTime': instance.bookOffTime?.toIso8601String(),
      'status': instance.status,
      'totalHours': instance.totalHours,
      'isLate': instance.isLate,
      'lateMinutes': instance.lateMinutes,
      'autoBookedOff': instance.autoBookedOff,
    };

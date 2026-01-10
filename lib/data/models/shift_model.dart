import 'package:json_annotation/json_annotation.dart';

part 'shift_model.g.dart';

/// Helper function to parse double from string or number (for Prisma Decimal fields)
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

/// Helper function to parse int from string or number
int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

@JsonSerializable()
class ShiftModel {
  final String id;
  final String? tenantId;
  final String? employeeId;
  final String siteId;
  final String? clientId;

  final SiteModel site;
  final ClientModel? client;

  final DateTime shiftDate;
  final DateTime startTime;
  final DateTime endTime;
  @JsonKey(defaultValue: 0)
  final int breakMinutes;
  final String status;
  final String? shiftType;
  final String? notes;
  final bool? checkCallRequired;

  final AttendanceModel? attendance;

  ShiftModel({
    required this.id,
    this.tenantId,
    this.employeeId,
    required this.siteId,
    this.clientId,
    required this.site,
    this.client,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    required this.breakMinutes,
    required this.status,
    this.shiftType,
    this.notes,
    this.checkCallRequired,
    this.attendance,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);
}

@JsonSerializable()
class SiteModel {
  final String id;
  final String name;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(fromJson: _parseDouble)
  final double? latitude;
  @JsonKey(fromJson: _parseDouble)
  final double? longitude;
  @JsonKey(defaultValue: false)
  final bool checkCallEnabled;
  @JsonKey(fromJson: _parseInt)
  final int? checkCallFrequency;

  SiteModel({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    required this.checkCallEnabled,
    this.checkCallFrequency,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) =>
      _$SiteModelFromJson(json);

  Map<String, dynamic> toJson() => _$SiteModelToJson(this);
}

@JsonSerializable()
class ClientModel {
  final String id;
  final String name;

  ClientModel({
    required this.id,
    required this.name,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientModelToJson(this);
}

@JsonSerializable()
class AttendanceModel {
  final String id;
  final DateTime? bookOnTime;
  final DateTime? bookOffTime;
  final String status;
  @JsonKey(fromJson: _parseDouble)
  final double? totalHours;
  final bool isLate;
  @JsonKey(fromJson: _parseInt)
  final int? lateMinutes;
  final bool autoBookedOff;

  AttendanceModel({
    required this.id,
    this.bookOnTime,
    this.bookOffTime,
    required this.status,
    this.totalHours,
    required this.isLate,
    this.lateMinutes,
    required this.autoBookedOff,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceModelToJson(this);
}

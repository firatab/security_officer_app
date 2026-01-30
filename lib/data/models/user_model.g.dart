// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map json) =>
    $checkedCreate('UserModel', json, ($checkedConvert) {
      final val = UserModel(
        id: $checkedConvert('id', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        tenantId: $checkedConvert('tenantId', (v) => v as String?),
        employee: $checkedConvert(
          'employee',
          (v) => v == null
              ? null
              : EmployeeModel.fromJson(Map<String, dynamic>.from(v as Map)),
        ),
        isSuperAdmin: $checkedConvert('isSuperAdmin', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'tenantId': instance.tenantId,
  'employee': instance.employee?.toJson(),
  'isSuperAdmin': instance.isSuperAdmin,
};

EmployeeModel _$EmployeeModelFromJson(Map json) =>
    $checkedCreate('EmployeeModel', json, ($checkedConvert) {
      final val = EmployeeModel(
        id: $checkedConvert('id', (v) => v as String),
        firstName: $checkedConvert('firstName', (v) => v as String),
        lastName: $checkedConvert('lastName', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String?),
        licenseNumber: $checkedConvert('licenseNumber', (v) => v as String?),
        status: $checkedConvert('status', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'licenseNumber': instance.licenseNumber,
      'status': instance.status,
    };

LoginResponse _$LoginResponseFromJson(Map json) =>
    $checkedCreate('LoginResponse', json, ($checkedConvert) {
      final val = LoginResponse(
        token: $checkedConvert('token', (v) => v as String),
        user: $checkedConvert(
          'user',
          (v) => UserModel.fromJson(Map<String, dynamic>.from(v as Map)),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{'token': instance.token, 'user': instance.user.toJson()};

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String? tenantId;
  final EmployeeModel? employee;
  final bool? isSuperAdmin;

  UserModel({
    required this.id,
    required this.email,
    this.tenantId,
    this.employee,
    this.isSuperAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class EmployeeModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? licenseNumber;
  final String status;

  EmployeeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.licenseNumber,
    required this.status,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  String get fullName => '$firstName $lastName';
}

@JsonSerializable()
class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  // Convenience getters for compatibility
  String get accessToken => token;
  String get refreshToken => token; // Backend uses single token

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Handle the nested 'data' structure from backend
    final data = json['data'] ?? json;
    return LoginResponse(
      token: data['token'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

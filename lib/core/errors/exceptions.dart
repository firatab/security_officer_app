/// Custom exceptions for the application
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.originalError});
}

class AuthException extends AppException {
  AuthException(super.message, {super.code, super.originalError});
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.code, super.originalError});
}

class DatabaseException extends AppException {
  DatabaseException(super.message, {super.code, super.originalError});
}

class LocationException extends AppException {
  LocationException(super.message, {super.code, super.originalError});
}

class SyncException extends AppException {
  SyncException(super.message, {super.code, super.originalError});
}

import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([String message = 'Network error occurred']) : super(message);
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException(String message, [this.statusCode, String? code])
      : super(message, code);

  @override
  List<Object?> get props => [message, code, statusCode];
}

class AuthException extends AppException {
  const AuthException([String message = 'Authentication failed', String? code])
      : super(message, code);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException(String message, [this.errors, String? code])
      : super(message, code);

  @override
  List<Object?> get props => [message, code, errors];
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Unauthorized access'])
      : super(message, '401');
}

class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found'])
      : super(message, '404');
}

class TimeoutException extends AppException {
  const TimeoutException([String message = 'Request timeout']) : super(message);
}

class CacheException extends AppException {
  const CacheException([String message = 'Cache error occurred']) : super(message);
}

class UnknownException extends AppException {
  const UnknownException([String message = 'An unknown error occurred'])
      : super(message);
}

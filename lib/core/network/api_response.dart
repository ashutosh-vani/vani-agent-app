import 'package:equatable/equatable.dart';

/// Generic API Response wrapper for handling different states
class ApiResponse<T> extends Equatable {
  final T? data;
  final String? message;
  final ApiStatus status;

  const ApiResponse._({
    this.data,
    this.message,
    required this.status,
  });

  const ApiResponse.loading() : this._(status: ApiStatus.loading);

  const ApiResponse.success(T data)
      : this._(
          data: data,
          status: ApiStatus.success,
        );

  const ApiResponse.error(String message)
      : this._(
          message: message,
          status: ApiStatus.error,
        );

  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success;
  bool get isError => status == ApiStatus.error;

  @override
  List<Object?> get props => [data, message, status];
}

enum ApiStatus {
  loading,
  success,
  error,
}

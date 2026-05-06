import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:vani_app/core/network/api_endpoints.dart';
import 'package:vani_app/core/network/dio_client.dart';
import 'package:vani_app/data/models/auth/auth_response.dart';
import 'package:vani_app/data/models/auth/login_request.dart';
import 'package:vani_app/data/models/auth/signup_request.dart';

class AuthApiService {
  final DioClient _dioClient;

  AuthApiService(this._dioClient);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
      options: Options(
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> signup(SignupRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.signup,
      data: request.toJson(),
      options: Options(
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<Map<String, dynamic>> verifyEmail(String token) async {
    final response = await _dioClient.post(
      ApiEndpoints.verifyEmail,
      data: {'token': token},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await _dioClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.resetPassword,
      data: {
        'token': token,
        'newPassword': newPassword,
      },
    );
    return response.data;
  }

  Future<void> logout() async {
    await _dioClient.post(ApiEndpoints.logout);
  }

  Future<Map<String, dynamic>> sendCall({
    required String phoneNumber,
    Map<String, dynamic>? additionalData,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.sendCall,
      data: {
        'phoneNumber': phoneNumber,
        ...?additionalData,
      },
    );
    return response.data;
  }

  Future<List<dynamic>> getTestCalls() async {
    final response = await _dioClient.get(ApiEndpoints.testCalls);
    return response.data as List<dynamic>;
  }

  Future<String> getGoogleAuthUrl() async {
    final response = await _dioClient.get(
      ApiEndpoints.googleAuthUrl,
      options: Options(
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
    );
    
    // Handle different response formats
    if (response.data is String) {
      return response.data as String;
    }
    
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      
      // Try different possible keys (authorization_url is the primary one)
      if (data['authorization_url'] != null) {
        return data['authorization_url'] as String;
      }
      if (data['url'] != null) {
        return data['url'] as String;
      }
      if (data['authUrl'] != null) {
        return data['authUrl'] as String;
      }
      if (data['googleUrl'] != null) {
        return data['googleUrl'] as String;
      }
      if (data['redirectUrl'] != null) {
        return data['redirectUrl'] as String;
      }
    }
    
    throw Exception('Invalid Google auth URL response format');
  }

  Future<AuthResponse> googleCallback({
    required String code,
    required String state,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.googleCallback,
      data: {
        'code': code,
        'state': state,
      },
      options: Options(
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<Map<String, dynamic>> verifyPhone({
    required String phoneNumber,
    required String code,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.verifyPhone,
      data: {
        'phoneNumber': phoneNumber,
        'code': code,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> setPhone(String phoneNumber) async {
    final response = await _dioClient.post(
      ApiEndpoints.setPhone,
      data: {'phoneNumber': phoneNumber},
    );
    return response.data;
  }
}

// Provider
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthApiService(dioClient);
});

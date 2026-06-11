import 'package:vani_app/data/models/auth/auth_response.dart';
import 'package:vani_app/data/models/auth/login_request.dart';
import 'package:vani_app/data/models/auth/signup_request.dart';

/// Mock Auth API Service for development and testing
/// Use this when the real API is not available or for UI testing
class MockAuthApiService {
  // Simulated delay to mimic network requests
  static const Duration _networkDelay = Duration(milliseconds: 800);

  Future<AuthResponse> login(LoginRequest request) async {
    await Future.delayed(_networkDelay);
    
    // Simulate successful login
    return AuthResponse(
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      id: 'user_${request.email.hashCode}',
      email: request.email,
      name: request.email.split('@')[0],
      emailVerified: true,
      message: 'Login successful',
    );
  }

  Future<AuthResponse> signup(SignupRequest request) async {
    await Future.delayed(_networkDelay);
    
    return AuthResponse(
      id: 'user_${request.email.hashCode}',
      email: request.email,
      name: request.name ?? request.email.split('@')[0],
      emailVerified: false,
      message: 'User created successfully. Please verify your email.',
    );
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String code,
  }) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Email verified successfully',
    };
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Password reset link sent to $email',
      'email': email,
    };
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Password reset successfully',
    };
  }

  Future<void> logout() async {
    await Future.delayed(_networkDelay);
  }

  Future<Map<String, dynamic>> sendCall({
    required String agentId,
    required String phoneNumber,
    required String contactName,
    String? customInstruction,
  }) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Call sent successfully',
      'test_call_id': 'call_${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  Future<List<dynamic>> getTestCalls() async {
    await Future.delayed(_networkDelay);
    
    return [
      {
        'id': 'call_1',
        'phoneNumber': '+1234567890',
        'duration': 120,
        'status': 'completed',
        'timestamp': DateTime.now().toIso8601String(),
      },
      {
        'id': 'call_2',
        'phoneNumber': '+0987654321',
        'duration': 45,
        'status': 'completed',
        'timestamp': DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
      },
    ];
  }

  Future<String> getGoogleAuthUrl() async {
    await Future.delayed(_networkDelay);
    
    return 'https://accounts.google.com/o/oauth2/v2/auth?client_id=mock&redirect_uri=mock';
  }

  Future<AuthResponse> googleCallback(String code) async {
    await Future.delayed(_networkDelay);
    
    return AuthResponse(
      accessToken: 'mock_google_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_google_refresh_token',
      id: 'google_user_${code.hashCode}',
      email: 'user@gmail.com',
      name: 'Google User',
      emailVerified: true,
      message: 'Google login successful',
    );
  }

  Future<Map<String, dynamic>> verifyPhone({
    required String firebaseIdToken,
  }) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Phone verified successfully',
      'phone_verified': true,
    };
  }

  Future<Map<String, dynamic>> setPhone(String phoneNumber) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Phone number set successfully',
      'phoneNumber': phoneNumber,
    };
  }
}

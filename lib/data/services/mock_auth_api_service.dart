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
      user: User(
        id: 'user_${request.email.hashCode}',
        email: request.email,
        name: request.email.split('@')[0],
        verified: true,
      ),
      message: 'Login successful',
    );
  }

  Future<AuthResponse> signup(SignupRequest request) async {
    await Future.delayed(_networkDelay);
    
    return AuthResponse(
      message: 'User created successfully. Please verify your email.',
      user: User(
        id: 'user_${request.email.hashCode}',
        email: request.email,
        name: request.name ?? request.email.split('@')[0],
        verified: false,
      ),
    );
  }

  Future<Map<String, dynamic>> verifyEmail(String token) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Email verified successfully',
      'verified': true,
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
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Password reset successfully',
      'success': true,
    };
  }

  Future<void> logout() async {
    await Future.delayed(_networkDelay);
  }

  Future<Map<String, dynamic>> sendCall({
    required String phoneNumber,
    Map<String, dynamic>? additionalData,
  }) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Call sent successfully',
      'phoneNumber': phoneNumber,
      'callId': 'call_${DateTime.now().millisecondsSinceEpoch}',
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
      user: User(
        id: 'google_user_${code.hashCode}',
        email: 'user@gmail.com',
        name: 'Google User',
        verified: true,
      ),
      message: 'Google login successful',
    );
  }

  Future<Map<String, dynamic>> verifyPhone({
    required String phoneNumber,
    required String code,
  }) async {
    await Future.delayed(_networkDelay);
    
    return {
      'message': 'Phone verified successfully',
      'phoneNumber': phoneNumber,
      'verified': true,
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

// Mock User model
class User {
  final String id;
  final String email;
  final String name;
  final bool verified;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.verified = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'verified': verified,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    verified: json['verified'] as bool? ?? false,
  );
}

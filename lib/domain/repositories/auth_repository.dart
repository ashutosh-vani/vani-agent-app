import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/core/storage/secure_storage_service.dart';
import 'package:vani_app/data/models/auth/auth_response.dart';
import 'package:vani_app/data/models/auth/login_request.dart';
import 'package:vani_app/data/models/auth/signup_request.dart';
import 'package:vani_app/data/models/user/user_model.dart';
import 'package:vani_app/data/services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _authApiService;
  final SecureStorageService _storageService;

  AuthRepository(this._authApiService, this._storageService);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authApiService.login(request);

      if (response.accessToken != null) {
        await _storageService.saveAccessToken(response.accessToken!);
      }
      if (response.refreshToken != null) {
        await _storageService.saveRefreshToken(response.refreshToken!);
      }
      
      // Get user data from response (either nested or at top level)
      final user = response.user;
      
      if (user != null) {
        await _storageService.saveUserId(user.id);
        await _storageService.saveUserEmail(user.email);
        return user;
      }

      throw const AuthException('Login failed: User data not received');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel> signup({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      final request = SignupRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      final response = await _authApiService.signup(request);

      if (response.accessToken != null) {
        await _storageService.saveAccessToken(response.accessToken!);
      }
      if (response.refreshToken != null) {
        await _storageService.saveRefreshToken(response.refreshToken!);
      }
      
      // Get user data from response (either nested or at top level)
      final user = response.user;
      
      if (user != null) {
        await _storageService.saveUserId(user.id);
        await _storageService.saveUserEmail(user.email);
        return user;
      }

      throw const AuthException('Signup failed: User data not received');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException('Signup failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _authApiService.logout();
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      await _storageService.clearAll();
    }
  }

  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  Future<String?> getAccessToken() async {
    return await _storageService.getAccessToken();
  }

  Future<void> verifyEmail(String token) async {
    try {
      await _authApiService.verifyEmail(token);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException('Email verification failed: ${e.toString()}');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _authApiService.forgotPassword(email);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException('Password reset request failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _authApiService.resetPassword(
        token: token,
        newPassword: newPassword,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException('Password reset failed: ${e.toString()}');
    }
  }

  Future<String> getGoogleAuthUrl() async {
    try {
      return await _authApiService.getGoogleAuthUrl();
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException('Failed to get Google auth URL: ${e.toString()}');
    }
  }

  Future<UserModel> googleCallback({
    required String code,
    required String state,
  }) async {
    try {
      final response = await _authApiService.googleCallback(
        code: code,
        state: state,
      );

      if (response.accessToken != null) {
        await _storageService.saveAccessToken(response.accessToken!);
      }
      if (response.refreshToken != null) {
        await _storageService.saveRefreshToken(response.refreshToken!);
      }
      
      // Get user data from response (either nested or at top level)
      final user = response.user;
      
      if (user != null) {
        await _storageService.saveUserId(user.id);
        await _storageService.saveUserEmail(user.email);
        return user;
      }

      throw const AuthException('Google login failed: User data not received');
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException('Google login failed: ${e.toString()}');
    }
  }
}

// Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authApiService = ref.watch(authApiServiceProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  return AuthRepository(authApiService, storageService);
});

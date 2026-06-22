import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  final Logger _logger = Logger();

  SecureStorageService(this._storage);

  // Keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  // Helper method to execute secure storage actions safely
  Future<T?> _safeRun<T>(Future<T?> Function() action) async {
    try {
      return await action();
    } on PlatformException catch (e) {
      _logger.e('Secure storage platform exception: $e');
      // If keystore or decryption fails, clear everything to recover
      try {
        await _storage.deleteAll();
      } catch (innerError) {
        _logger.e('Failed to clear secure storage after error: $innerError');
      }
      return null;
    } catch (e) {
      _logger.e('Secure storage unexpected error: $e');
      return null;
    }
  }

  // Access Token
  Future<void> saveAccessToken(String token) async {
    await _safeRun(() => _storage.write(key: _accessTokenKey, value: token));
  }

  Future<String?> getAccessToken() async {
    return await _safeRun(() => _storage.read(key: _accessTokenKey));
  }

  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _safeRun(() => _storage.write(key: _refreshTokenKey, value: token));
  }

  Future<String?> getRefreshToken() async {
    return await _safeRun(() => _storage.read(key: _refreshTokenKey));
  }

  // User ID
  Future<void> saveUserId(String userId) async {
    await _safeRun(() => _storage.write(key: _userIdKey, value: userId));
  }

  Future<String?> getUserId() async {
    return await _safeRun(() => _storage.read(key: _userIdKey));
  }

  // User Email
  Future<void> saveUserEmail(String email) async {
    await _safeRun(() => _storage.write(key: _userEmailKey, value: email));
  }

  Future<String?> getUserEmail() async {
    return await _safeRun(() => _storage.read(key: _userEmailKey));
  }

  // Clear all tokens
  Future<void> clearTokens() async {
    await _safeRun(() async {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
    });
  }

  // Clear all data
  Future<void> clearAll() async {
    await _safeRun(() => _storage.deleteAll());
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

// Provider
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  return SecureStorageService(storage);
});

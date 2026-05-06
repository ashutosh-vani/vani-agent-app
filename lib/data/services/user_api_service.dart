import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/network/api_endpoints.dart';
import 'package:vani_app/core/network/dio_client.dart';

class UserApiService {
  final DioClient _dioClient;

  UserApiService(this._dioClient);

  Future<Map<String, dynamic>> getUserStatus() async {
    final response = await _dioClient.get(ApiEndpoints.userStatus);
    return response.data;
  }

  Future<Map<String, dynamic>> assignDemoNumber() async {
    final response = await _dioClient.post(ApiEndpoints.assignDemoNumber);
    return response.data;
  }
}

// Provider
final userApiServiceProvider = Provider<UserApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UserApiService(dioClient);
});

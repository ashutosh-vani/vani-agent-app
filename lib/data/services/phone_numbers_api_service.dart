import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/network/api_endpoints.dart';
import 'package:vani_app/core/network/dio_client.dart';
import 'package:vani_app/data/models/phone_numbers/phone_number_model.dart';

class PhoneNumbersApiService {
  final DioClient _dioClient;

  PhoneNumbersApiService(this._dioClient);

  Future<List<AvailablePhoneNumberModel>> getAvailablePhoneNumbers({
    String? country,
    String? areaCode,
    String? type,
    String? region,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.availablePhoneNumbers,
      queryParameters: {
        if (country != null) 'country': country,
        if (areaCode != null) 'areaCode': areaCode,
        if (type != null) 'type': type,
        if (region != null) 'region': region,
      },
    );
    return (response.data as List)
        .map((json) => AvailablePhoneNumberModel.fromJson(json))
        .toList();
  }

  Future<List<PhoneNumberModel>> getPhoneNumbers() async {
    final response = await _dioClient.get(ApiEndpoints.phoneNumbers);
    return (response.data as List)
        .map((json) => PhoneNumberModel.fromJson(json))
        .toList();
  }

  Future<PhoneNumberModel> createPhoneNumber({
    required String phoneNumber,
    String? friendlyName,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.phoneNumbers,
      data: {
        'phoneNumber': phoneNumber,
        if (friendlyName != null) 'friendlyName': friendlyName,
      },
    );
    return PhoneNumberModel.fromJson(response.data);
  }

  Future<PhoneNumberModel> getPhoneNumber(String phoneId) async {
    final response = await _dioClient.get(
      ApiEndpoints.phoneNumber(phoneId),
    );
    return PhoneNumberModel.fromJson(response.data);
  }

  Future<PhoneNumberModel> updatePhoneNumber({
    required String phoneId,
    String? friendlyName,
    bool? isActive,
  }) async {
    final response = await _dioClient.patch(
      ApiEndpoints.phoneNumber(phoneId),
      data: {
        if (friendlyName != null) 'friendlyName': friendlyName,
        if (isActive != null) 'isActive': isActive,
      },
    );
    return PhoneNumberModel.fromJson(response.data);
  }

  Future<void> deletePhoneNumber(String phoneId) async {
    await _dioClient.delete(ApiEndpoints.phoneNumber(phoneId));
  }

  Future<PhoneNumberModel> updateInboundAgent({
    required String phoneId,
    required String agentId,
  }) async {
    final response = await _dioClient.patch(
      ApiEndpoints.updateInboundAgent(phoneId),
      data: {'agentId': agentId},
    );
    return PhoneNumberModel.fromJson(response.data);
  }
}

// Provider
final phoneNumbersApiServiceProvider = Provider<PhoneNumbersApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PhoneNumbersApiService(dioClient);
});

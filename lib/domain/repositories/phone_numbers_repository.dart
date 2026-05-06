import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/data/models/phone_numbers/phone_number_model.dart';
import 'package:vani_app/data/services/phone_numbers_api_service.dart';

class PhoneNumbersRepository {
  final PhoneNumbersApiService _apiService;

  PhoneNumbersRepository(this._apiService);

  Future<List<AvailablePhoneNumberModel>> getAvailablePhoneNumbers({
    String? country,
    String? areaCode,
    String? type,
    String? region,
  }) async {
    try {
      return await _apiService.getAvailablePhoneNumbers(
        country: country,
        areaCode: areaCode,
        type: type,
        region: region,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch available phone numbers: ${e.toString()}');
    }
  }

  Future<List<PhoneNumberModel>> getPhoneNumbers() async {
    try {
      return await _apiService.getPhoneNumbers();
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch phone numbers: ${e.toString()}');
    }
  }

  Future<PhoneNumberModel> createPhoneNumber({
    required String phoneNumber,
    String? friendlyName,
  }) async {
    try {
      return await _apiService.createPhoneNumber(
        phoneNumber: phoneNumber,
        friendlyName: friendlyName,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to create phone number: ${e.toString()}');
    }
  }

  Future<PhoneNumberModel> getPhoneNumber(String phoneId) async {
    try {
      return await _apiService.getPhoneNumber(phoneId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch phone number: ${e.toString()}');
    }
  }

  Future<PhoneNumberModel> updatePhoneNumber({
    required String phoneId,
    String? friendlyName,
    bool? isActive,
  }) async {
    try {
      return await _apiService.updatePhoneNumber(
        phoneId: phoneId,
        friendlyName: friendlyName,
        isActive: isActive,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to update phone number: ${e.toString()}');
    }
  }

  Future<void> deletePhoneNumber(String phoneId) async {
    try {
      await _apiService.deletePhoneNumber(phoneId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to delete phone number: ${e.toString()}');
    }
  }

  Future<PhoneNumberModel> updateInboundAgent({
    required String phoneId,
    required String agentId,
  }) async {
    try {
      return await _apiService.updateInboundAgent(
        phoneId: phoneId,
        agentId: agentId,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to update inbound agent: ${e.toString()}');
    }
  }
}

// Provider
final phoneNumbersRepositoryProvider = Provider<PhoneNumbersRepository>((ref) {
  final apiService = ref.watch(phoneNumbersApiServiceProvider);
  return PhoneNumbersRepository(apiService);
});

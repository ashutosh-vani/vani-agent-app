import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/data/models/phone_numbers/phone_number_model.dart';
import 'package:vani_app/domain/repositories/phone_numbers_repository.dart';

// Phone Numbers State
class PhoneNumbersState {
  final List<PhoneNumberModel> phoneNumbers;
  final List<AvailablePhoneNumberModel> availableNumbers;
  final bool isLoading;
  final bool isLoadingAvailable;
  final String? error;

  PhoneNumbersState({
    this.phoneNumbers = const [],
    this.availableNumbers = const [],
    this.isLoading = false,
    this.isLoadingAvailable = false,
    this.error,
  });

  PhoneNumbersState copyWith({
    List<PhoneNumberModel>? phoneNumbers,
    List<AvailablePhoneNumberModel>? availableNumbers,
    bool? isLoading,
    bool? isLoadingAvailable,
    String? error,
  }) {
    return PhoneNumbersState(
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      availableNumbers: availableNumbers ?? this.availableNumbers,
      isLoading: isLoading ?? this.isLoading,
      isLoadingAvailable: isLoadingAvailable ?? this.isLoadingAvailable,
      error: error,
    );
  }
}

// Phone Numbers Notifier
class PhoneNumbersNotifier extends StateNotifier<PhoneNumbersState> {
  final PhoneNumbersRepository _repository;

  PhoneNumbersNotifier(this._repository) : super(PhoneNumbersState());

  Future<void> loadPhoneNumbers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final phoneNumbers = await _repository.getPhoneNumbers();
      state = state.copyWith(
        phoneNumbers: phoneNumbers,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load phone numbers',
      );
    }
  }

  Future<void> loadAvailableNumbers({
    String? country,
    String? areaCode,
    String? type,
    String? region,
  }) async {
    state = state.copyWith(isLoadingAvailable: true, error: null);
    try {
      final availableNumbers = await _repository.getAvailablePhoneNumbers(
        country: country,
        areaCode: areaCode,
        type: type,
        region: region,
      );
      state = state.copyWith(
        availableNumbers: availableNumbers,
        isLoadingAvailable: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoadingAvailable: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingAvailable: false,
        error: 'Failed to load available numbers',
      );
    }
  }

  Future<void> createPhoneNumber({
    required String phoneNumber,
    String? friendlyName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newNumber = await _repository.createPhoneNumber(
        phoneNumber: phoneNumber,
        friendlyName: friendlyName,
      );
      state = state.copyWith(
        phoneNumbers: [...state.phoneNumbers, newNumber],
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create phone number',
      );
      rethrow;
    }
  }

  Future<void> updatePhoneNumber({
    required String phoneId,
    String? friendlyName,
    bool? isActive,
  }) async {
    try {
      final updatedNumber = await _repository.updatePhoneNumber(
        phoneId: phoneId,
        friendlyName: friendlyName,
        isActive: isActive,
      );

      final updatedList = state.phoneNumbers.map((number) {
        return number.id == phoneId ? updatedNumber : number;
      }).toList();

      state = state.copyWith(phoneNumbers: updatedList);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(error: 'Failed to update phone number');
      rethrow;
    }
  }

  Future<void> deletePhoneNumber(String phoneId) async {
    try {
      await _repository.deletePhoneNumber(phoneId);
      
      final updatedList = state.phoneNumbers
          .where((number) => number.id != phoneId)
          .toList();
      
      state = state.copyWith(phoneNumbers: updatedList);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete phone number');
      rethrow;
    }
  }

  Future<void> updateInboundAgent({
    required String phoneId,
    required String agentId,
  }) async {
    try {
      final updatedNumber = await _repository.updateInboundAgent(
        phoneId: phoneId,
        agentId: agentId,
      );

      final updatedList = state.phoneNumbers.map((number) {
        return number.id == phoneId ? updatedNumber : number;
      }).toList();

      state = state.copyWith(phoneNumbers: updatedList);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(error: 'Failed to update inbound agent');
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final phoneNumbersProvider =
    StateNotifierProvider<PhoneNumbersNotifier, PhoneNumbersState>((ref) {
  final repository = ref.watch(phoneNumbersRepositoryProvider);
  return PhoneNumbersNotifier(repository);
});

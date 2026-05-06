import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/data/models/credits/credits_model.dart';
import 'package:vani_app/data/services/credits_api_service.dart';

class CreditsRepository {
  final CreditsApiService _apiService;

  CreditsRepository(this._apiService);

  Future<CreditBalanceModel> getCreditBalance() async {
    try {
      return await _apiService.getCreditBalance();
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch credit balance: ${e.toString()}');
    }
  }

  Future<List<CreditTransactionModel>> getCreditTransactions({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      return await _apiService.getCreditTransactions(
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch credit transactions: ${e.toString()}');
    }
  }

  Future<CreditBalanceModel> purchaseCredits({
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      return await _apiService.purchaseCredits(
        amount: amount,
        paymentMethod: paymentMethod,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to purchase credits: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> verifyPayment({
    required String paymentId,
  }) async {
    try {
      return await _apiService.verifyPayment(paymentId: paymentId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to verify payment: ${e.toString()}');
    }
  }
}

// Provider
final creditsRepositoryProvider = Provider<CreditsRepository>((ref) {
  final apiService = ref.watch(creditsApiServiceProvider);
  return CreditsRepository(apiService);
});

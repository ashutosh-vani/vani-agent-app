import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/data/models/subscriptions/subscription_model.dart';
import 'package:vani_app/data/services/subscriptions_api_service.dart';

class SubscriptionsRepository {
  final SubscriptionsApiService _apiService;

  SubscriptionsRepository(this._apiService);

  Future<List<SubscriptionTierModel>> getSubscriptionTiers() async {
    try {
      return await _apiService.getSubscriptionTiers();
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch subscription tiers: ${e.toString()}');
    }
  }

  Future<CurrentSubscriptionModel> getCurrentSubscription() async {
    try {
      return await _apiService.getCurrentSubscription();
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch current subscription: ${e.toString()}');
    }
  }

  Future<CurrentSubscriptionModel> changeTier({
    required String tierId,
  }) async {
    try {
      return await _apiService.changeTier(tierId: tierId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to change subscription tier: ${e.toString()}');
    }
  }
}

// Provider
final subscriptionsRepositoryProvider = Provider<SubscriptionsRepository>((ref) {
  final apiService = ref.watch(subscriptionsApiServiceProvider);
  return SubscriptionsRepository(apiService);
});

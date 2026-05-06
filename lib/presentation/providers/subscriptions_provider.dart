import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/data/models/subscriptions/subscription_model.dart';
import 'package:vani_app/domain/repositories/subscriptions_repository.dart';

// Subscriptions State
class SubscriptionsState {
  final List<SubscriptionTierModel> tiers;
  final CurrentSubscriptionModel? currentSubscription;
  final bool isLoading;
  final bool isChangingTier;
  final String? error;

  SubscriptionsState({
    this.tiers = const [],
    this.currentSubscription,
    this.isLoading = false,
    this.isChangingTier = false,
    this.error,
  });

  SubscriptionsState copyWith({
    List<SubscriptionTierModel>? tiers,
    CurrentSubscriptionModel? currentSubscription,
    bool? isLoading,
    bool? isChangingTier,
    String? error,
  }) {
    return SubscriptionsState(
      tiers: tiers ?? this.tiers,
      currentSubscription: currentSubscription ?? this.currentSubscription,
      isLoading: isLoading ?? this.isLoading,
      isChangingTier: isChangingTier ?? this.isChangingTier,
      error: error,
    );
  }
}

// Subscriptions Notifier
class SubscriptionsNotifier extends StateNotifier<SubscriptionsState> {
  final SubscriptionsRepository _repository;

  SubscriptionsNotifier(this._repository) : super(SubscriptionsState());

  Future<void> loadSubscriptionTiers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final tiers = await _repository.getSubscriptionTiers();
      state = state.copyWith(
        tiers: tiers,
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
        error: 'Failed to load subscription tiers',
      );
    }
  }

  Future<void> loadCurrentSubscription() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final subscription = await _repository.getCurrentSubscription();
      state = state.copyWith(
        currentSubscription: subscription,
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
        error: 'Failed to load current subscription',
      );
    }
  }

  Future<void> changeTier(String tierId) async {
    state = state.copyWith(isChangingTier: true, error: null);
    try {
      final updatedSubscription = await _repository.changeTier(tierId: tierId);
      state = state.copyWith(
        currentSubscription: updatedSubscription,
        isChangingTier: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isChangingTier: false,
        error: e.message,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isChangingTier: false,
        error: 'Failed to change subscription tier',
      );
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final subscriptionsProvider =
    StateNotifierProvider<SubscriptionsNotifier, SubscriptionsState>((ref) {
  final repository = ref.watch(subscriptionsRepositoryProvider);
  return SubscriptionsNotifier(repository);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/data/models/calls/call_history_model.dart';
import 'package:vani_app/data/models/calls/call_statistics_model.dart';
import 'package:vani_app/domain/repositories/calls_repository.dart';

// Calls State
class CallsState {
  final List<CallHistoryModel> callHistory;
  final CallStatisticsModel? statistics;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;

  CallsState({
    this.callHistory = const [],
    this.statistics,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  CallsState copyWith({
    List<CallHistoryModel>? callHistory,
    CallStatisticsModel? statistics,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return CallsState(
      callHistory: callHistory ?? this.callHistory,
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Calls Notifier
class CallsNotifier extends StateNotifier<CallsState> {
  final CallsRepository _repository;

  CallsNotifier(this._repository) : super(CallsState());

  Future<void> loadCallHistory({
    bool refresh = false,
    String? startDate,
    String? endDate,
  }) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        hasMore: true,
      );
    } else {
      if (!state.hasMore || state.isLoadingMore) return;
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      final response = await _repository.getCallHistory(
        page: refresh ? 1 : state.currentPage,
        limit: 20,
        startDate: startDate,
        endDate: endDate,
      );

      final newCalls = response.calls;
      final hasMore = newCalls.length >= 20;

      state = state.copyWith(
        callHistory: refresh ? newCalls : [...state.callHistory, ...newCalls],
        isLoading: false,
        isLoadingMore: false,
        currentPage: refresh ? 2 : state.currentPage + 1,
        hasMore: hasMore,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: 'Failed to load call history',
      );
    }
  }

  Future<void> loadStatistics({
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final statistics = await _repository.getCallStatistics(
        period: period,
        startDate: startDate,
        endDate: endDate,
      );
      state = state.copyWith(statistics: statistics);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load statistics');
    }
  }

  Future<Map<String, dynamic>?> downloadRecording(String callId, {bool force = false}) async {
    try {
      return await _repository.downloadRecording(callId, force: force);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(error: 'Failed to download recording');
      return null;
    }
  }

  Future<Map<String, dynamic>?> regenerateSummary(String callId) async {
    try {
      final result = await _repository.regenerateSummary(callId);
      // Refresh the call history to get updated summary
      await loadCallHistory(refresh: true);
      return result;
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(error: 'Failed to regenerate summary');
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final callsProvider = StateNotifierProvider<CallsNotifier, CallsState>((ref) {
  final repository = ref.watch(callsRepositoryProvider);
  return CallsNotifier(repository);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/data/models/calls/call_history_model.dart';
import 'package:vani_app/data/models/calls/call_statistics_model.dart';
import 'package:vani_app/data/services/calls_api_service.dart';

class CallsRepository {
  final CallsApiService _apiService;

  CallsRepository(this._apiService);

  Future<CallHistoryResponse> getCallHistory({
    int? page,
    int? limit,
    String? startDate,
    String? endDate,
  }) async {
    try {
      return await _apiService.getCallHistory(
        page: page,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch call history: ${e.toString()}');
    }
  }

  Future<CallStatisticsModel> getCallStatistics({
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    try {
      return await _apiService.getCallStatistics(
        period: period,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch call statistics: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getCallContacts() async {
    try {
      return await _apiService.getCallContacts();
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch call contacts: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> downloadRecording(String callId, {bool force = false}) async {
    try {
      return await _apiService.downloadRecording(callId, force: force);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to download recording: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> regenerateSummary(String callId) async {
    try {
      return await _apiService.regenerateSummary(callId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to regenerate summary: ${e.toString()}');
    }
  }
}

// Provider
final callsRepositoryProvider = Provider<CallsRepository>((ref) {
  final apiService = ref.watch(callsApiServiceProvider);
  return CallsRepository(apiService);
});

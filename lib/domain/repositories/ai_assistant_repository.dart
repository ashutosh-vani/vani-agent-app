import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/data/models/ai_assistant/conversation_model.dart';
import 'package:vani_app/data/services/ai_assistant_api_service.dart';

class AiAssistantRepository {
  final AiAssistantApiService _apiService;

  AiAssistantRepository(this._apiService);

  Future<RunAgentResponse> sendMessage({
    String? conversationId,
    required String message,
    Map<String, dynamic>? context,
  }) async {
    try {
      final request = RunAgentRequest(
        conversationId: conversationId,
        message: message,
        context: context,
      );
      return await _apiService.runAgent(request);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to send message: ${e.toString()}');
    }
  }

  Future<List<ConversationModel>> getConversations({
    int? page,
    int? limit,
  }) async {
    try {
      return await _apiService.getConversations(page: page, limit: limit);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch conversations: ${e.toString()}');
    }
  }

  Future<ConversationModel> createConversation({String? title}) async {
    try {
      return await _apiService.createConversation(title: title);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to create conversation: ${e.toString()}');
    }
  }

  Future<ConversationModel> getConversation(String conversationId) async {
    try {
      return await _apiService.getConversation(conversationId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to fetch conversation: ${e.toString()}');
    }
  }

  Future<ConversationModel> renameConversation({
    required String conversationId,
    required String title,
  }) async {
    try {
      return await _apiService.renameConversation(
        conversationId: conversationId,
        title: title,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to rename conversation: ${e.toString()}');
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      await _apiService.deleteConversation(conversationId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Failed to delete conversation: ${e.toString()}');
    }
  }
}

// Provider
final aiAssistantRepositoryProvider = Provider<AiAssistantRepository>((ref) {
  final apiService = ref.watch(aiAssistantApiServiceProvider);
  return AiAssistantRepository(apiService);
});

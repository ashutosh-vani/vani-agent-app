import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/network/api_endpoints.dart';
import 'package:vani_app/core/network/dio_client.dart';
import 'package:vani_app/data/models/ai_assistant/conversation_model.dart';

class AiAssistantApiService {
  final DioClient _dioClient;

  AiAssistantApiService(this._dioClient);

  Future<RunAgentResponse> runAgent(RunAgentRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.runAgent,
      data: request.toJson(),
    );
    return RunAgentResponse.fromJson(response.data);
  }

  Future<List<ConversationModel>> getConversations({
    int? page,
    int? limit,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.conversations,
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );
    return (response.data as List)
        .map((json) => ConversationModel.fromJson(json))
        .toList();
  }

  Future<ConversationModel> createConversation({
    String? title,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.conversations,
      data: {
        if (title != null) 'title': title,
      },
    );
    return ConversationModel.fromJson(response.data);
  }

  Future<ConversationModel> getConversation(String conversationId) async {
    final response = await _dioClient.get(
      ApiEndpoints.conversation(conversationId),
    );
    return ConversationModel.fromJson(response.data);
  }

  Future<ConversationModel> renameConversation({
    required String conversationId,
    required String title,
  }) async {
    final response = await _dioClient.patch(
      ApiEndpoints.conversation(conversationId),
      data: {'title': title},
    );
    return ConversationModel.fromJson(response.data);
  }

  Future<void> deleteConversation(String conversationId) async {
    await _dioClient.delete(
      ApiEndpoints.conversation(conversationId),
    );
  }
}

// Provider
final aiAssistantApiServiceProvider = Provider<AiAssistantApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AiAssistantApiService(dioClient);
});

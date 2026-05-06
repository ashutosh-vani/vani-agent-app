import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/network/api_endpoints.dart';
import 'package:vani_app/core/network/dio_client.dart';
import 'package:vani_app/models/whatsapp_conversation_model.dart';

class WhatsAppApiService {
  final DioClient _dioClient;

  WhatsAppApiService(this._dioClient);

  /// Get list of conversations
  Future<List<WhatsAppConversation>> getConversations() async {
    final response = await _dioClient.get(
      ApiEndpoints.whatsappConversations,
    );
    return (response.data as List<dynamic>)
        .map((e) => WhatsAppConversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create a new conversation
  Future<WhatsAppConversationDetail> createConversation({
    required String contactNumber,
    required String connectionId,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.whatsappConversations,
      data: {
        'contact_number': contactNumber,
        'connection_id': connectionId,
      },
    );
    return WhatsAppConversationDetail.fromJson(response.data);
  }

  /// Get conversation details
  Future<WhatsAppConversationDetail> getConversation(String conversationId) async {
    final response = await _dioClient.get(
      ApiEndpoints.whatsappConversation(conversationId),
    );
    return WhatsAppConversationDetail.fromJson(response.data);
  }

  /// Update conversation settings
  Future<WhatsAppConversationDetail> updateConversationSettings({
    required String conversationId,
    bool? aiEnabled,
    String? aiSystemPrompt,
  }) async {
    final response = await _dioClient.patch(
      ApiEndpoints.whatsappConversationSettings(conversationId),
      data: {
        if (aiEnabled != null) 'ai_enabled': aiEnabled,
        if (aiSystemPrompt != null) 'ai_system_prompt': aiSystemPrompt,
      },
    );
    return WhatsAppConversationDetail.fromJson(response.data);
  }

  /// Send a message
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required SendMessageRequest request,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.whatsappSendMessage(conversationId),
      data: request.toJson(),
    );
    return response.data as Map<String, dynamic>;
  }

  /// Bulk send messages
  Future<Map<String, dynamic>> bulkSendMessages({
    required List<String> phoneNumbers,
    required String connectionId,
    required String messageType,
    String? text,
    String? templateName,
    String? templateId,
    String? languageCode,
    List<String>? bodyParams,
    List<String>? headerParams,
    String? headerMediaUrl,
    String? headerMediaType,
    List<Map<String, dynamic>>? buttonParams,
  }) async {
    final response = await _dioClient.post(
      ApiEndpoints.whatsappBulkSend,
      data: {
        'phone_numbers': phoneNumbers,
        'connection_id': connectionId,
        'message_type': messageType,
        if (text != null) 'text': text,
        if (templateName != null) 'template_name': templateName,
        if (templateId != null) 'template_id': templateId,
        if (languageCode != null) 'language_code': languageCode,
        if (bodyParams != null) 'body_params': bodyParams,
        if (headerParams != null) 'header_params': headerParams,
        if (headerMediaUrl != null) 'header_media_url': headerMediaUrl,
        if (headerMediaType != null) 'header_media_type': headerMediaType,
        if (buttonParams != null) 'button_params': buttonParams,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get webhook configuration
  Future<Map<String, dynamic>> getWebhookConfig() async {
    final response = await _dioClient.get(
      ApiEndpoints.whatsappWebhookConfig,
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get WhatsApp message templates for a connection
  Future<List<Map<String, dynamic>>> getTemplates(String connectionId) async {
    final response = await _dioClient.get(
      ApiEndpoints.whatsappTemplates(connectionId),
    );
    final data = response.data as Map<String, dynamic>;
    return (data['templates'] as List<dynamic>?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
  }

  /// Check if user has WhatsApp integration
  Future<WhatsAppIntegrationStatus> checkIntegrationStatus() async {
    try {
      final conversations = await getConversations();
      if (conversations.isNotEmpty) {
        return WhatsAppIntegrationStatus(
          hasIntegration: true,
          connectionId: conversations.first.connectionId,
        );
      }
      return WhatsAppIntegrationStatus(hasIntegration: false);
    } catch (e) {
      // If error, assume no integration
      return WhatsAppIntegrationStatus(hasIntegration: false);
    }
  }

  /// Update lead status for a conversation
  Future<void> updateLeadStatus({
    required String conversationId,
    required String status,
  }) async {
    await _dioClient.patch(
      ApiEndpoints.whatsappConversationLeadStatus(conversationId),
      data: {
        'lead_status': status,
      },
    );
  }
}

// Provider
final whatsappApiServiceProvider = Provider<WhatsAppApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return WhatsAppApiService(dioClient);
});

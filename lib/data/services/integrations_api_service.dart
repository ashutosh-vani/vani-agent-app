import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/network/api_endpoints.dart';
import 'package:vani_app/core/network/dio_client.dart';
import 'package:vani_app/models/integration_model.dart';

class IntegrationsApiService {
  final DioClient _dioClient;

  IntegrationsApiService(this._dioClient);

  // ==================== Meta Connections ====================

  /// Get list of Meta connections
  Future<List<MetaConnection>> getMetaConnections() async {
    final response = await _dioClient.get(
      ApiEndpoints.metaConnections,
    );
    return (response.data as List<dynamic>)
        .map((e) => MetaConnection.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create a new Meta connection
  Future<MetaConnection> createMetaConnection(
      CreateMetaConnectionRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.metaConnections,
      data: request.toJson(),
    );
    return MetaConnection.fromJson(response.data);
  }

  /// Update a Meta connection
  Future<MetaConnection> updateMetaConnection({
    required String connectionId,
    String? appId,
    String? appSecret,
    String? accessToken,
    String? pageId,
    String? adAccountId,
    String? instagramActorId,
    String? businessId,
    String? pixelId,
    String? tokenType,
    bool? isActive,
  }) async {
    final response = await _dioClient.patch(
      ApiEndpoints.metaConnection(connectionId),
      data: {
        if (appId != null) 'app_id': appId,
        if (appSecret != null) 'app_secret': appSecret,
        if (accessToken != null) 'access_token': accessToken,
        if (pageId != null) 'page_id': pageId,
        if (adAccountId != null) 'ad_account_id': adAccountId,
        if (instagramActorId != null) 'instagram_actor_id': instagramActorId,
        if (businessId != null) 'business_id': businessId,
        if (pixelId != null) 'pixel_id': pixelId,
        if (tokenType != null) 'token_type': tokenType,
        if (isActive != null) 'is_active': isActive,
      },
    );
    return MetaConnection.fromJson(response.data);
  }

  /// Delete a Meta connection
  Future<void> deleteMetaConnection(String connectionId) async {
    await _dioClient.delete(
      ApiEndpoints.metaConnection(connectionId),
    );
  }

  /// Validate a Meta connection
  Future<MetaValidationResult> validateMetaConnection(
      String connectionId) async {
    final response = await _dioClient.post(
      ApiEndpoints.validateMetaConnection(connectionId),
    );
    return MetaValidationResult.fromJson(response.data);
  }

  // ==================== WhatsApp Connections ====================

  /// Get list of WhatsApp connections
  Future<List<WhatsAppConnection>> getWhatsAppConnections() async {
    final response = await _dioClient.get(
      ApiEndpoints.whatsappConnections,
    );
    return (response.data as List<dynamic>)
        .map((e) => WhatsAppConnection.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create a new WhatsApp connection
  Future<WhatsAppConnection> createWhatsAppConnection(
      CreateWhatsAppConnectionRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.whatsappConnections,
      data: request.toJson(),
    );
    return WhatsAppConnection.fromJson(response.data);
  }

  /// Update a WhatsApp connection
  Future<WhatsAppConnection> updateWhatsAppConnection({
    required String connectionId,
    String? businessPhoneId,
    String? apiToken,
    String? businessAccountId,
    String? appId,
    String? appSecret,
    bool? isActive,
    bool? whatsappAgentEnabled,
    String? whatsappAgentSystemPrompt,
  }) async {
    final response = await _dioClient.patch(
      ApiEndpoints.whatsappConnection(connectionId),
      data: {
        if (businessPhoneId != null) 'business_phone_id': businessPhoneId,
        if (apiToken != null) 'api_token': apiToken,
        if (businessAccountId != null)
          'business_account_id': businessAccountId,
        if (appId != null) 'app_id': appId,
        if (appSecret != null) 'app_secret': appSecret,
        if (isActive != null) 'is_active': isActive,
        if (whatsappAgentEnabled != null)
          'whatsapp_agent_enabled': whatsappAgentEnabled,
        if (whatsappAgentSystemPrompt != null)
          'whatsapp_agent_system_prompt': whatsappAgentSystemPrompt,
      },
    );
    return WhatsAppConnection.fromJson(response.data);
  }

  /// Delete a WhatsApp connection
  Future<void> deleteWhatsAppConnection(String connectionId) async {
    await _dioClient.delete(
      ApiEndpoints.whatsappConnection(connectionId),
    );
  }

  /// Validate a WhatsApp connection
  Future<WhatsAppValidationResult> validateWhatsAppConnection(
      String connectionId) async {
    final response = await _dioClient.get(
      ApiEndpoints.validateWhatsAppConnection(connectionId),
    );
    return WhatsAppValidationResult.fromJson(response.data);
  }

  /// Get WhatsApp templates for a connection
  Future<WhatsAppTemplatesResponse> getWhatsAppTemplates(
      String connectionId) async {
    final response = await _dioClient.get(
      ApiEndpoints.whatsappTemplates(connectionId),
    );
    return WhatsAppTemplatesResponse.fromJson(response.data);
  }
}

// Provider
final integrationsApiServiceProvider = Provider<IntegrationsApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return IntegrationsApiService(dioClient);
});

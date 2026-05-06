import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/data/services/whatsapp_api_service.dart';
import 'package:vani_app/models/whatsapp_conversation_model.dart';

class WhatsAppState {
  final bool isLoading;
  final bool hasIntegration;
  final List<WhatsAppConversation> conversations;
  final WhatsAppConversationDetail? selectedConversation;
  final String? error;
  final bool isSendingMessage;
  final List<Map<String, dynamic>> templates;
  final bool isLoadingTemplates;

  WhatsAppState({
    this.isLoading = false,
    this.hasIntegration = false,
    this.conversations = const [],
    this.selectedConversation,
    this.error,
    this.isSendingMessage = false,
    this.templates = const [],
    this.isLoadingTemplates = false,
  });

  WhatsAppState copyWith({
    bool? isLoading,
    bool? hasIntegration,
    List<WhatsAppConversation>? conversations,
    WhatsAppConversationDetail? selectedConversation,
    String? error,
    bool? isSendingMessage,
    List<Map<String, dynamic>>? templates,
    bool? isLoadingTemplates,
    bool clearError = false,
    bool clearSelectedConversation = false,
  }) {
    return WhatsAppState(
      isLoading: isLoading ?? this.isLoading,
      hasIntegration: hasIntegration ?? this.hasIntegration,
      conversations: conversations ?? this.conversations,
      selectedConversation: clearSelectedConversation
          ? null
          : (selectedConversation ?? this.selectedConversation),
      error: clearError ? null : (error ?? this.error),
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      templates: templates ?? this.templates,
      isLoadingTemplates: isLoadingTemplates ?? this.isLoadingTemplates,
    );
  }
}

class WhatsAppNotifier extends StateNotifier<WhatsAppState> {
  final WhatsAppApiService _apiService;

  WhatsAppNotifier(this._apiService) : super(WhatsAppState());

  /// Check if user has WhatsApp integration
  Future<void> checkIntegrationStatus() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final status = await _apiService.checkIntegrationStatus();
      state = state.copyWith(
        hasIntegration: status.hasIntegration,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        hasIntegration: false,
      );
    }
  }

  /// Load conversations
  Future<void> loadConversations() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final conversations = await _apiService.getConversations();
      state = state.copyWith(
        conversations: conversations,
        hasIntegration: conversations.isNotEmpty,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Load a specific conversation
  Future<void> loadConversation(String conversationId) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final conversation = await _apiService.getConversation(conversationId);
      state = state.copyWith(
        selectedConversation: conversation,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Create a new conversation
  Future<WhatsAppConversationDetail?> createConversation({
    required String contactNumber,
    required String connectionId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final conversation = await _apiService.createConversation(
        contactNumber: contactNumber,
        connectionId: connectionId,
      );
      
      // Reload conversations list
      await loadConversations();
      
      state = state.copyWith(
        selectedConversation: conversation,
        isLoading: false,
      );
      
      return conversation;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }

  /// Update conversation settings
  Future<void> updateConversationSettings({
    required String conversationId,
    bool? aiEnabled,
    String? aiSystemPrompt,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final conversation = await _apiService.updateConversationSettings(
        conversationId: conversationId,
        aiEnabled: aiEnabled,
        aiSystemPrompt: aiSystemPrompt,
      );
      state = state.copyWith(
        selectedConversation: conversation,
        isLoading: false,
      );
      
      // Reload conversations list to update the list view
      await loadConversations();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Send a message
  Future<bool> sendMessage({
    required String conversationId,
    required SendMessageRequest request,
  }) async {
    try {
      state = state.copyWith(isSendingMessage: true, clearError: true);
      await _apiService.sendMessage(
        conversationId: conversationId,
        request: request,
      );
      
      // Reload the conversation to get the new message
      await loadConversation(conversationId);
      
      state = state.copyWith(isSendingMessage: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isSendingMessage: false,
      );
      return false;
    }
  }

  /// Clear selected conversation
  void clearSelectedConversation() {
    state = state.copyWith(clearSelectedConversation: true);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Load templates for a connection
  Future<void> loadTemplates(String connectionId) async {
    try {
      state = state.copyWith(isLoadingTemplates: true);
      final templates = await _apiService.getTemplates(connectionId);
      state = state.copyWith(
        templates: templates,
        isLoadingTemplates: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTemplates: false,
      );
    }
  }

  /// Update lead status for a conversation
  Future<void> updateLeadStatus({
    required String conversationId,
    required LeadStatus status,
  }) async {
    try {
      // Optimistically update the UI
      final updatedConversations = state.conversations.map((conv) {
        if (conv.id == conversationId) {
          return conv.copyWith(leadStatus: status);
        }
        return conv;
      }).toList();
      
      state = state.copyWith(conversations: updatedConversations);
      
      // Make API call to update on backend
      await _apiService.updateLeadStatus(
        conversationId: conversationId,
        status: status.toApiString(),
      );
    } catch (e) {
      // Revert on error
      await loadConversations();
      state = state.copyWith(error: 'Failed to update lead status: ${e.toString()}');
    }
  }
}

// Provider
final whatsappProvider = StateNotifierProvider<WhatsAppNotifier, WhatsAppState>((ref) {
  final apiService = ref.watch(whatsappApiServiceProvider);
  return WhatsAppNotifier(apiService);
});

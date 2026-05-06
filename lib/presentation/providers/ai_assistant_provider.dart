import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/exceptions/app_exception.dart';
import 'package:vani_app/data/models/ai_assistant/conversation_model.dart';
import 'package:vani_app/domain/repositories/ai_assistant_repository.dart';

// AI Assistant State
class AiAssistantState {
  final List<ConversationModel> conversations;
  final ConversationModel? currentConversation;
  final List<MessageModel> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;

  AiAssistantState({
    this.conversations = const [],
    this.currentConversation,
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  AiAssistantState copyWith({
    List<ConversationModel>? conversations,
    ConversationModel? currentConversation,
    List<MessageModel>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return AiAssistantState(
      conversations: conversations ?? this.conversations,
      currentConversation: currentConversation ?? this.currentConversation,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
    );
  }
}

// AI Assistant Notifier
class AiAssistantNotifier extends StateNotifier<AiAssistantState> {
  final AiAssistantRepository _repository;

  AiAssistantNotifier(this._repository) : super(AiAssistantState());

  Future<void> loadConversations() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final conversations = await _repository.getConversations();
      state = state.copyWith(
        conversations: conversations,
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
        error: 'Failed to load conversations',
      );
    }
  }

  Future<void> loadConversation(String conversationId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final conversation = await _repository.getConversation(conversationId);
      state = state.copyWith(
        currentConversation: conversation,
        messages: conversation.messages ?? [],
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
        error: 'Failed to load conversation',
      );
    }
  }

  Future<void> sendMessage({
    String? conversationId,
    required String message,
    Map<String, dynamic>? context,
  }) async {
    // Add user message to UI immediately
    final userMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: message,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isSending: true,
      error: null,
    );

    try {
      final response = await _repository.sendMessage(
        conversationId: conversationId ?? state.currentConversation?.id,
        message: message,
        context: context,
      );

      // Add assistant response to messages
      state = state.copyWith(
        messages: [...state.messages, response.message],
        currentConversation: state.currentConversation?.copyWith(
          id: response.conversationId,
        ),
        isSending: false,
      );
    } on AppException catch (e) {
      // Remove the user message if sending failed
      final messages = List<MessageModel>.from(state.messages);
      messages.removeLast();
      
      state = state.copyWith(
        messages: messages,
        isSending: false,
        error: e.message,
      );
    } catch (e) {
      // Remove the user message if sending failed
      final messages = List<MessageModel>.from(state.messages);
      messages.removeLast();
      
      state = state.copyWith(
        messages: messages,
        isSending: false,
        error: 'Failed to send message',
      );
    }
  }

  Future<void> createNewConversation({String? title}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final conversation = await _repository.createConversation(title: title);
      state = state.copyWith(
        currentConversation: conversation,
        messages: [],
        conversations: [conversation, ...state.conversations],
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
        error: 'Failed to create conversation',
      );
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      await _repository.deleteConversation(conversationId);
      
      final updatedConversations = state.conversations
          .where((c) => c.id != conversationId)
          .toList();
      
      state = state.copyWith(
        conversations: updatedConversations,
        currentConversation: state.currentConversation?.id == conversationId
            ? null
            : state.currentConversation,
        messages: state.currentConversation?.id == conversationId ? [] : state.messages,
      );
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete conversation');
    }
  }

  void clearCurrentConversation() {
    state = state.copyWith(
      currentConversation: null,
      messages: [],
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final aiAssistantProvider =
    StateNotifierProvider<AiAssistantNotifier, AiAssistantState>((ref) {
  final repository = ref.watch(aiAssistantRepositoryProvider);
  return AiAssistantNotifier(repository);
});

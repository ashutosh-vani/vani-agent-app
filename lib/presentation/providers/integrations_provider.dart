import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/data/services/integrations_api_service.dart';
import 'package:vani_app/models/integration_model.dart';

class IntegrationsState {
  final bool isLoading;
  final List<MetaConnection> metaConnections;
  final List<WhatsAppConnection> whatsappConnections;
  final WhatsAppTemplatesResponse? whatsappTemplates;
  final String? error;
  final bool isValidating;
  final MetaValidationResult? metaValidationResult;
  final WhatsAppValidationResult? whatsappValidationResult;

  IntegrationsState({
    this.isLoading = false,
    this.metaConnections = const [],
    this.whatsappConnections = const [],
    this.whatsappTemplates,
    this.error,
    this.isValidating = false,
    this.metaValidationResult,
    this.whatsappValidationResult,
  });

  IntegrationsState copyWith({
    bool? isLoading,
    List<MetaConnection>? metaConnections,
    List<WhatsAppConnection>? whatsappConnections,
    WhatsAppTemplatesResponse? whatsappTemplates,
    String? error,
    bool? isValidating,
    MetaValidationResult? metaValidationResult,
    WhatsAppValidationResult? whatsappValidationResult,
    bool clearError = false,
    bool clearValidationResults = false,
    bool clearTemplates = false,
  }) {
    return IntegrationsState(
      isLoading: isLoading ?? this.isLoading,
      metaConnections: metaConnections ?? this.metaConnections,
      whatsappConnections: whatsappConnections ?? this.whatsappConnections,
      whatsappTemplates: clearTemplates
          ? null
          : (whatsappTemplates ?? this.whatsappTemplates),
      error: clearError ? null : (error ?? this.error),
      isValidating: isValidating ?? this.isValidating,
      metaValidationResult: clearValidationResults
          ? null
          : (metaValidationResult ?? this.metaValidationResult),
      whatsappValidationResult: clearValidationResults
          ? null
          : (whatsappValidationResult ?? this.whatsappValidationResult),
    );
  }

  bool get hasMetaConnection => metaConnections.isNotEmpty;
  bool get hasWhatsAppConnection => whatsappConnections.isNotEmpty;
  bool get hasAnyConnection => hasMetaConnection || hasWhatsAppConnection;
}

class IntegrationsNotifier extends StateNotifier<IntegrationsState> {
  final IntegrationsApiService _apiService;

  IntegrationsNotifier(this._apiService) : super(IntegrationsState());

  // ==================== Meta Connections ====================

  /// Load all Meta connections
  Future<void> loadMetaConnections() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final connections = await _apiService.getMetaConnections();
      state = state.copyWith(
        metaConnections: connections,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Create a new Meta connection
  Future<MetaConnection?> createMetaConnection(
      CreateMetaConnectionRequest request) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final connection = await _apiService.createMetaConnection(request);

      // Reload connections list
      await loadMetaConnections();

      state = state.copyWith(isLoading: false);
      return connection;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }

  /// Update a Meta connection
  Future<bool> updateMetaConnection({
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
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.updateMetaConnection(
        connectionId: connectionId,
        appId: appId,
        appSecret: appSecret,
        accessToken: accessToken,
        pageId: pageId,
        adAccountId: adAccountId,
        instagramActorId: instagramActorId,
        businessId: businessId,
        pixelId: pixelId,
        tokenType: tokenType,
        isActive: isActive,
      );

      // Reload connections list
      await loadMetaConnections();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  /// Delete a Meta connection
  Future<bool> deleteMetaConnection(String connectionId) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.deleteMetaConnection(connectionId);

      // Reload connections list
      await loadMetaConnections();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  /// Validate a Meta connection
  Future<MetaValidationResult?> validateMetaConnection(
      String connectionId) async {
    try {
      state = state.copyWith(
        isValidating: true,
        clearError: true,
        clearValidationResults: true,
      );
      final result = await _apiService.validateMetaConnection(connectionId);
      state = state.copyWith(
        metaValidationResult: result,
        isValidating: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isValidating: false,
      );
      return null;
    }
  }

  // ==================== WhatsApp Connections ====================

  /// Load all WhatsApp connections
  Future<void> loadWhatsAppConnections() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final connections = await _apiService.getWhatsAppConnections();
      state = state.copyWith(
        whatsappConnections: connections,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Create a new WhatsApp connection
  Future<WhatsAppConnection?> createWhatsAppConnection(
      CreateWhatsAppConnectionRequest request) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final connection = await _apiService.createWhatsAppConnection(request);

      // Reload connections list
      await loadWhatsAppConnections();

      state = state.copyWith(isLoading: false);
      return connection;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }

  /// Update a WhatsApp connection
  Future<bool> updateWhatsAppConnection({
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
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.updateWhatsAppConnection(
        connectionId: connectionId,
        businessPhoneId: businessPhoneId,
        apiToken: apiToken,
        businessAccountId: businessAccountId,
        appId: appId,
        appSecret: appSecret,
        isActive: isActive,
        whatsappAgentEnabled: whatsappAgentEnabled,
        whatsappAgentSystemPrompt: whatsappAgentSystemPrompt,
      );

      // Reload connections list
      await loadWhatsAppConnections();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  /// Delete a WhatsApp connection
  Future<bool> deleteWhatsAppConnection(String connectionId) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.deleteWhatsAppConnection(connectionId);

      // Reload connections list
      await loadWhatsAppConnections();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  /// Validate a WhatsApp connection
  Future<WhatsAppValidationResult?> validateWhatsAppConnection(
      String connectionId) async {
    try {
      state = state.copyWith(
        isValidating: true,
        clearError: true,
        clearValidationResults: true,
      );
      final result =
          await _apiService.validateWhatsAppConnection(connectionId);
      state = state.copyWith(
        whatsappValidationResult: result,
        isValidating: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isValidating: false,
      );
      return null;
    }
  }

  /// Load WhatsApp templates for a connection
  Future<void> loadWhatsAppTemplates(String connectionId) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final templates = await _apiService.getWhatsAppTemplates(connectionId);
      state = state.copyWith(
        whatsappTemplates: templates,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Load all connections (both Meta and WhatsApp)
  Future<void> loadAllConnections() async {
    await Future.wait([
      loadMetaConnections(),
      loadWhatsAppConnections(),
    ]);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear validation results
  void clearValidationResults() {
    state = state.copyWith(clearValidationResults: true);
  }
}

// Provider
final integrationsProvider =
    StateNotifierProvider<IntegrationsNotifier, IntegrationsState>((ref) {
  final apiService = ref.watch(integrationsApiServiceProvider);
  return IntegrationsNotifier(apiService);
});

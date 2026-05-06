import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/data/services/meta_ads_api_service.dart';
import 'package:vani_app/models/meta_ads_model.dart';

class MetaAdsState {
  final bool isLoading;
  final String? error;
  
  // OAuth
  final MetaOAuthConnection? connection;
  
  // Assets
  final MetaAdAssetsResponse? assets;
  
  // Lead Forms
  final List<MetaLeadForm> leadForms;
  
  // Account Overview
  final MetaAccountOverview? accountOverview;
  
  // Targeting
  final List<MetaInterest> interests;
  final List<MetaGeoLocation> geoLocations;
  
  // Leadgen
  final LeadgenWebhookInfo? webhookInfo;
  final List<PollingConfig> pollingConfigs;
  final SyncLeadsResponse? lastSyncResult;

  MetaAdsState({
    this.isLoading = false,
    this.error,
    this.connection,
    this.assets,
    this.leadForms = const [],
    this.accountOverview,
    this.interests = const [],
    this.geoLocations = const [],
    this.webhookInfo,
    this.pollingConfigs = const [],
    this.lastSyncResult,
  });

  MetaAdsState copyWith({
    bool? isLoading,
    String? error,
    MetaOAuthConnection? connection,
    MetaAdAssetsResponse? assets,
    List<MetaLeadForm>? leadForms,
    MetaAccountOverview? accountOverview,
    List<MetaInterest>? interests,
    List<MetaGeoLocation>? geoLocations,
    LeadgenWebhookInfo? webhookInfo,
    List<PollingConfig>? pollingConfigs,
    SyncLeadsResponse? lastSyncResult,
    bool clearError = false,
    bool clearConnection = false,
    bool clearAssets = false,
    bool clearAccountOverview = false,
    bool clearInterests = false,
    bool clearGeoLocations = false,
    bool clearWebhookInfo = false,
    bool clearLastSyncResult = false,
  }) {
    return MetaAdsState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      connection: clearConnection ? null : (connection ?? this.connection),
      assets: clearAssets ? null : (assets ?? this.assets),
      leadForms: leadForms ?? this.leadForms,
      accountOverview: clearAccountOverview ? null : (accountOverview ?? this.accountOverview),
      interests: clearInterests ? [] : (interests ?? this.interests),
      geoLocations: clearGeoLocations ? [] : (geoLocations ?? this.geoLocations),
      webhookInfo: clearWebhookInfo ? null : (webhookInfo ?? this.webhookInfo),
      pollingConfigs: pollingConfigs ?? this.pollingConfigs,
      lastSyncResult: clearLastSyncResult ? null : (lastSyncResult ?? this.lastSyncResult),
    );
  }
}

class MetaAdsNotifier extends StateNotifier<MetaAdsState> {
  final MetaAdsApiService _apiService;

  MetaAdsNotifier(this._apiService) : super(MetaAdsState());

  // ==================== OAuth ====================

  /// Select OAuth assets after authentication
  Future<MetaOAuthConnection?> selectOAuthAssets(
      MetaOAuthSelectRequest request) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final connection = await _apiService.selectOAuthAssets(request);
      state = state.copyWith(
        connection: connection,
        isLoading: false,
      );
      return connection;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }

  /// Disconnect OAuth
  Future<bool> disconnectOAuth() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.disconnectOAuth();
      state = state.copyWith(
        isLoading: false,
        clearConnection: true,
        clearAssets: true,
        clearAccountOverview: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  // ==================== Assets ====================

  /// Load ad assets
  Future<void> loadAssets() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final assets = await _apiService.listAdAssets();
      state = state.copyWith(
        assets: assets,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Upload asset
  Future<UploadAssetResponse?> uploadAsset(File file) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final response = await _apiService.uploadAsset(file);
      
      // Reload assets after upload
      await loadAssets();
      
      state = state.copyWith(isLoading: false);
      return response;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }

  // ==================== Lead Forms ====================

  /// Load lead forms
  Future<void> loadLeadForms() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final forms = await _apiService.listLeadForms();
      state = state.copyWith(
        leadForms: forms,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Create lead form
  Future<CreateLeadFormResponse?> createLeadForm(
      CreateLeadFormRequest request) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final response = await _apiService.createLeadForm(request);
      
      // Reload forms after creation
      await loadLeadForms();
      
      state = state.copyWith(isLoading: false);
      return response;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }

  // ==================== Account & Campaigns ====================

  /// Load account overview
  Future<void> loadAccountOverview({String datePreset = 'last_30d'}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final overview = await _apiService.getAccountOverview(
        datePreset: datePreset,
      );
      state = state.copyWith(
        accountOverview: overview,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Update campaign status
  Future<bool> updateCampaignStatus(String campaignId, String status) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.updateCampaignStatus(campaignId, status);
      
      // Reload overview after update
      await loadAccountOverview();
      
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

  /// Update ad set status
  Future<bool> updateAdsetStatus(String adsetId, String status) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.updateAdsetStatus(adsetId, status);
      
      // Reload overview after update
      await loadAccountOverview();
      
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

  // ==================== Targeting ====================

  /// Search interests
  Future<void> searchInterests(String query) async {
    if (query.length < 2) {
      state = state.copyWith(clearInterests: true);
      return;
    }

    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final response = await _apiService.searchInterests(query);
      state = state.copyWith(
        interests: response.interests,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Search geo locations
  Future<void> searchGeoLocations({
    required String query,
    String locationTypes = 'city,region',
    String? countryCode,
  }) async {
    if (query.isEmpty) {
      state = state.copyWith(clearGeoLocations: true);
      return;
    }

    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final response = await _apiService.searchGeoLocations(
        query: query,
        locationTypes: locationTypes,
        countryCode: countryCode,
      );
      state = state.copyWith(
        geoLocations: response.locations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Clear targeting search results
  void clearTargetingResults() {
    state = state.copyWith(
      clearInterests: true,
      clearGeoLocations: true,
    );
  }

  // ==================== Drafts ====================

  /// Publish draft
  Future<PublishDraftResponse?> publishDraft(String draftId) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final response = await _apiService.publishDraft(draftId);
      
      // Reload overview after publishing
      await loadAccountOverview();
      
      state = state.copyWith(isLoading: false);
      return response;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }

  // ==================== Leadgen Webhook ====================

  /// Load webhook info
  Future<void> loadWebhookInfo() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final info = await _apiService.getLeadgenWebhookInfo();
      state = state.copyWith(
        webhookInfo: info,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Update webhook verify token
  Future<bool> updateWebhookVerifyToken(String verifyToken) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.updateLeadgenVerifyToken(verifyToken);
      
      // Reload webhook info
      await loadWebhookInfo();
      
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

  /// Sync leads from form
  Future<SyncLeadsResponse?> syncLeads(SyncLeadsRequest request) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final response = await _apiService.syncLeads(request);
      state = state.copyWith(
        lastSyncResult: response,
        isLoading: false,
      );
      return response;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }

  // ==================== Polling Configs ====================

  /// Load polling configs
  Future<void> loadPollingConfigs() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final configs = await _apiService.listPollingConfigs();
      state = state.copyWith(
        pollingConfigs: configs,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Create polling config
  Future<PollingConfig?> createPollingConfig(
      CreatePollingConfigRequest request) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      final config = await _apiService.createPollingConfig(request);
      
      // Reload configs after creation
      await loadPollingConfigs();
      
      state = state.copyWith(isLoading: false);
      return config;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }

  /// Update polling config
  Future<bool> updatePollingConfig(
    String configId,
    UpdatePollingConfigRequest request,
  ) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.updatePollingConfig(configId, request);
      
      // Reload configs after update
      await loadPollingConfigs();
      
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

  /// Delete polling config
  Future<bool> deletePollingConfig(String configId) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);
      await _apiService.deletePollingConfig(configId);
      
      // Reload configs after deletion
      await loadPollingConfigs();
      
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

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// Provider
final metaAdsProvider =
    StateNotifierProvider<MetaAdsNotifier, MetaAdsState>((ref) {
  final apiService = ref.watch(metaAdsApiServiceProvider);
  return MetaAdsNotifier(apiService);
});

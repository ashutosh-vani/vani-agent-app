import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/core/network/api_endpoints.dart';
import 'package:vani_app/core/network/dio_client.dart';
import 'package:vani_app/models/meta_ads_model.dart';

class MetaAdsApiService {
  final DioClient _dioClient;

  MetaAdsApiService(this._dioClient);

  // ==================== OAuth ====================

  /// Select Meta OAuth assets after authentication
  Future<MetaOAuthConnection> selectOAuthAssets(
      MetaOAuthSelectRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.metaAdsOAuthSelect,
      data: request.toJson(),
    );
    return MetaOAuthConnection.fromJson(response.data);
  }

  /// Disconnect Meta OAuth connection
  Future<void> disconnectOAuth() async {
    await _dioClient.delete(
      ApiEndpoints.metaAdsOAuthDisconnect,
    );
  }

  // ==================== Assets ====================

  /// List Meta ad assets (images and videos)
  Future<MetaAdAssetsResponse> listAdAssets() async {
    final response = await _dioClient.get(
      ApiEndpoints.metaAdsAssets,
    );
    return MetaAdAssetsResponse.fromJson(response.data);
  }

  /// Upload asset to Meta
  Future<UploadAssetResponse> uploadAsset(File file) async {
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _dioClient.post(
      ApiEndpoints.metaAdsUploadAsset,
      data: formData,
    );
    return UploadAssetResponse.fromJson(response.data);
  }

  // ==================== Lead Forms ====================

  /// List Meta lead forms
  Future<List<MetaLeadForm>> listLeadForms() async {
    final response = await _dioClient.get(
      ApiEndpoints.metaAdsLeadForms,
    );
    return (response.data as List<dynamic>)
        .map((e) => MetaLeadForm.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create Meta lead form
  Future<CreateLeadFormResponse> createLeadForm(
      CreateLeadFormRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.metaAdsLeadForms,
      data: request.toJson(),
    );
    return CreateLeadFormResponse.fromJson(response.data);
  }

  // ==================== Account & Campaigns ====================

  /// Get Meta account overview with campaigns
  Future<MetaAccountOverview> getAccountOverview({
    String datePreset = 'last_30d',
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.metaAdsAccountOverview,
      queryParameters: {
        'date_preset': datePreset,
      },
    );
    return MetaAccountOverview.fromJson(response.data);
  }

  /// Update campaign status (pause/resume)
  Future<Map<String, dynamic>> updateCampaignStatus(
    String campaignId,
    String status,
  ) async {
    final response = await _dioClient.patch(
      ApiEndpoints.metaAdsCampaignStatus(campaignId),
      data: {'status': status},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Update ad set status (pause/resume)
  Future<Map<String, dynamic>> updateAdsetStatus(
    String adsetId,
    String status,
  ) async {
    final response = await _dioClient.patch(
      ApiEndpoints.metaAdsAdsetStatus(adsetId),
      data: {'status': status},
    );
    return response.data as Map<String, dynamic>;
  }

  // ==================== Targeting ====================

  /// Search Meta interests for targeting
  Future<MetaInterestSearchResponse> searchInterests(String query) async {
    final response = await _dioClient.get(
      ApiEndpoints.metaAdsInterestSearch,
      queryParameters: {
        'q': query,
      },
    );
    return MetaInterestSearchResponse.fromJson(response.data);
  }

  /// Search Meta geo locations for targeting
  Future<MetaGeoSearchResponse> searchGeoLocations({
    required String query,
    String locationTypes = 'city,region',
    String? countryCode,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.metaAdsGeoSearch,
      queryParameters: {
        'q': query,
        'location_types': locationTypes,
        if (countryCode != null) 'country_code': countryCode,
      },
    );
    return MetaGeoSearchResponse.fromJson(response.data);
  }

  // ==================== Drafts ====================

  /// Publish a draft to Meta Ads
  Future<PublishDraftResponse> publishDraft(String draftId) async {
    final response = await _dioClient.post(
      ApiEndpoints.metaAdsDraftPublish(draftId),
    );
    return PublishDraftResponse.fromJson(response.data);
  }

  // ==================== Leadgen Webhook ====================

  /// Get leadgen webhook info
  Future<LeadgenWebhookInfo> getLeadgenWebhookInfo() async {
    final response = await _dioClient.get(
      ApiEndpoints.metaAdsLeadgenWebhookInfo,
    );
    return LeadgenWebhookInfo.fromJson(response.data);
  }

  /// Update leadgen webhook verify token
  Future<Map<String, dynamic>> updateLeadgenVerifyToken(
      String verifyToken) async {
    final response = await _dioClient.patch(
      ApiEndpoints.metaAdsLeadgenWebhookVerifyToken,
      data: {'verify_token': verifyToken},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Sync leads from a form
  Future<SyncLeadsResponse> syncLeads(SyncLeadsRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.metaAdsLeadgenSync,
      data: request.toJson(),
    );
    return SyncLeadsResponse.fromJson(response.data);
  }

  // ==================== Polling Configs ====================

  /// List polling configs
  Future<List<PollingConfig>> listPollingConfigs() async {
    final response = await _dioClient.get(
      ApiEndpoints.metaAdsLeadgenPollingConfigs,
    );
    return (response.data as List<dynamic>)
        .map((e) => PollingConfig.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create polling config
  Future<PollingConfig> createPollingConfig(
      CreatePollingConfigRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.metaAdsLeadgenPollingConfigs,
      data: request.toJson(),
    );
    return PollingConfig.fromJson(response.data);
  }

  /// Update polling config
  Future<PollingConfig> updatePollingConfig(
    String configId,
    UpdatePollingConfigRequest request,
  ) async {
    final response = await _dioClient.patch(
      ApiEndpoints.metaAdsLeadgenPollingConfig(configId),
      data: request.toJson(),
    );
    return PollingConfig.fromJson(response.data);
  }

  /// Delete polling config
  Future<void> deletePollingConfig(String configId) async {
    await _dioClient.delete(
      ApiEndpoints.metaAdsLeadgenPollingConfig(configId),
    );
  }
}

// Provider
final metaAdsApiServiceProvider = Provider<MetaAdsApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MetaAdsApiService(dioClient);
});

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta_ads_model.freezed.dart';
part 'meta_ads_model.g.dart';

// ==================== OAuth Models ====================

@freezed
class MetaOAuthSelectRequest with _$MetaOAuthSelectRequest {
  const factory MetaOAuthSelectRequest({
    @JsonKey(name: 'ad_account_id') required String adAccountId,
    @JsonKey(name: 'page_id') required String pageId,
    @JsonKey(name: 'instagram_actor_id') String? instagramActorId,
    @JsonKey(name: 'business_id') String? businessId,
    @JsonKey(name: 'pixel_id') String? pixelId,
  }) = _MetaOAuthSelectRequest;

  factory MetaOAuthSelectRequest.fromJson(Map<String, dynamic> json) =>
      _$MetaOAuthSelectRequestFromJson(json);
}

@freezed
class MetaOAuthConnection with _$MetaOAuthConnection {
  const factory MetaOAuthConnection({
    required String id,
    required String provider,
    @JsonKey(name: 'meta_oauth_user_id') String? metaOAuthUserId,
    @JsonKey(name: 'meta_oauth_name') String? metaOAuthName,
    @JsonKey(name: 'meta_ad_account_id') String? metaAdAccountId,
    @JsonKey(name: 'meta_page_id') String? metaPageId,
    @JsonKey(name: 'meta_instagram_actor_id') String? metaInstagramActorId,
    @JsonKey(name: 'meta_business_id') String? metaBusinessId,
    @JsonKey(name: 'meta_pixel_id') String? metaPixelId,
    @JsonKey(name: 'meta_granted_scopes') List<String>? metaGrantedScopes,
    @JsonKey(name: 'meta_token_expires_at') DateTime? metaTokenExpiresAt,
    @JsonKey(name: 'meta_last_validated_at') DateTime? metaLastValidatedAt,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MetaOAuthConnection;

  factory MetaOAuthConnection.fromJson(Map<String, dynamic> json) =>
      _$MetaOAuthConnectionFromJson(json);
}

// ==================== Asset Models ====================

@freezed
class MetaAdImage with _$MetaAdImage {
  const factory MetaAdImage({
    required String hash,
    String? name,
    String? url,
    @JsonKey(name: 'url_128') String? url128,
    @JsonKey(name: 'permalink_url') String? permalinkUrl,
    int? width,
    int? height,
    @JsonKey(name: 'created_time') String? createdTime,
  }) = _MetaAdImage;

  factory MetaAdImage.fromJson(Map<String, dynamic> json) =>
      _$MetaAdImageFromJson(json);
}

@freezed
class MetaAdVideo with _$MetaAdVideo {
  const factory MetaAdVideo({
    required String id,
    String? title,
    String? description,
    String? picture,
    String? source,
    int? length,
    @JsonKey(name: 'created_time') String? createdTime,
  }) = _MetaAdVideo;

  factory MetaAdVideo.fromJson(Map<String, dynamic> json) =>
      _$MetaAdVideoFromJson(json);
}

@freezed
class MetaAdAssetsResponse with _$MetaAdAssetsResponse {
  const factory MetaAdAssetsResponse({
    @Default([]) List<MetaAdImage> images,
    @Default([]) List<MetaAdVideo> videos,
    @JsonKey(name: 'images_total') @Default(0) int imagesTotal,
    @JsonKey(name: 'videos_total') @Default(0) int videosTotal,
  }) = _MetaAdAssetsResponse;

  factory MetaAdAssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$MetaAdAssetsResponseFromJson(json);
}

@freezed
class UploadAssetResponse with _$UploadAssetResponse {
  const factory UploadAssetResponse({
    @JsonKey(name: 'asset_type') required String assetType,
    @JsonKey(name: 'meta_id') required String metaId,
    String? name,
    String? url,
  }) = _UploadAssetResponse;

  factory UploadAssetResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadAssetResponseFromJson(json);
}

// ==================== Lead Form Models ====================

@freezed
class LeadFormQuestion with _$LeadFormQuestion {
  const factory LeadFormQuestion({
    required String type,
    required String key,
    String? label,
    @JsonKey(name: 'inline_context') String? inlineContext,
    List<LeadFormQuestionOption>? options,
  }) = _LeadFormQuestion;

  factory LeadFormQuestion.fromJson(Map<String, dynamic> json) =>
      _$LeadFormQuestionFromJson(json);
}

@freezed
class LeadFormQuestionOption with _$LeadFormQuestionOption {
  const factory LeadFormQuestionOption({
    required String value,
    String? key,
  }) = _LeadFormQuestionOption;

  factory LeadFormQuestionOption.fromJson(Map<String, dynamic> json) =>
      _$LeadFormQuestionOptionFromJson(json);
}

@freezed
class LeadFormPrivacyPolicy with _$LeadFormPrivacyPolicy {
  const factory LeadFormPrivacyPolicy({
    required String url,
    @JsonKey(name: 'link_text') String? linkText,
  }) = _LeadFormPrivacyPolicy;

  factory LeadFormPrivacyPolicy.fromJson(Map<String, dynamic> json) =>
      _$LeadFormPrivacyPolicyFromJson(json);
}

@freezed
class LeadFormContextCard with _$LeadFormContextCard {
  const factory LeadFormContextCard({
    String? title,
    String? style,
    @Default([]) List<dynamic> content,
    @JsonKey(name: 'button_text') String? buttonText,
  }) = _LeadFormContextCard;

  factory LeadFormContextCard.fromJson(Map<String, dynamic> json) =>
      _$LeadFormContextCardFromJson(json);
}

@freezed
class LeadFormThankYouPage with _$LeadFormThankYouPage {
  const factory LeadFormThankYouPage({
    String? title,
    String? body,
    @JsonKey(name: 'button_type') String? buttonType,
    @JsonKey(name: 'button_text') String? buttonText,
    @JsonKey(name: 'website_url') String? websiteUrl,
    @JsonKey(name: 'business_phone_number') String? businessPhoneNumber,
    @JsonKey(name: 'short_message') String? shortMessage,
  }) = _LeadFormThankYouPage;

  factory LeadFormThankYouPage.fromJson(Map<String, dynamic> json) =>
      _$LeadFormThankYouPageFromJson(json);
}

@freezed
class MetaLeadForm with _$MetaLeadForm {
  const factory MetaLeadForm({
    required String id,
    String? name,
    String? status,
    @JsonKey(name: 'created_time') String? createdTime,
    @JsonKey(name: 'question_count') int? questionCount,
    List<dynamic>? questions,
  }) = _MetaLeadForm;

  factory MetaLeadForm.fromJson(Map<String, dynamic> json) =>
      _$MetaLeadFormFromJson(json);
}

@freezed
class CreateLeadFormRequest with _$CreateLeadFormRequest {
  const factory CreateLeadFormRequest({
    required String name,
    required List<LeadFormQuestion> questions,
    @JsonKey(name: 'privacy_policy') required LeadFormPrivacyPolicy privacyPolicy,
    @JsonKey(name: 'context_card') LeadFormContextCard? contextCard,
    @JsonKey(name: 'thank_you_page') LeadFormThankYouPage? thankYouPage,
    @JsonKey(name: 'is_optimized_for_quality') @Default(false) bool isOptimizedForQuality,
    @JsonKey(name: 'block_display_for_non_targeted_viewer') @Default(true) bool blockDisplayForNonTargetedViewer,
    @Default('EN_US') String locale,
    @JsonKey(name: 'question_page_custom_headline') String? questionPageCustomHeadline,
  }) = _CreateLeadFormRequest;

  factory CreateLeadFormRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateLeadFormRequestFromJson(json);
}

@freezed
class CreateLeadFormResponse with _$CreateLeadFormResponse {
  const factory CreateLeadFormResponse({
    required String id,
    String? name,
  }) = _CreateLeadFormResponse;

  factory CreateLeadFormResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateLeadFormResponseFromJson(json);
}

// ==================== Campaign Models ====================

@freezed
class MetaAdAccount with _$MetaAdAccount {
  const factory MetaAdAccount({
    @JsonKey(name: 'account_id') String? accountId,
    String? name,
    String? currency,
    @JsonKey(fromJson: _parseNumericString) String? balance,
    @JsonKey(name: 'amount_spent', fromJson: _parseNumericString) String? amountSpent,
    @JsonKey(name: 'spend_cap') String? spendCap,
    @JsonKey(name: 'account_status') int? accountStatus,
  }) = _MetaAdAccount;

  factory MetaAdAccount.fromJson(Map<String, dynamic> json) =>
      _$MetaAdAccountFromJson(json);
}

// Helper function to parse numeric values as strings while preserving decimals
String? _parseNumericString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num) return value.toString();
  return value.toString();
}

@freezed
class CampaignInsights with _$CampaignInsights {
  const factory CampaignInsights({
    String? spend,
    String? impressions,
    String? clicks,
    String? reach,
    @Default(0) int leads,
  }) = _CampaignInsights;

  factory CampaignInsights.fromJson(Map<String, dynamic> json) =>
      _$CampaignInsightsFromJson(json);
}

@freezed
class MetaCampaign with _$MetaCampaign {
  const factory MetaCampaign({
    required String id,
    String? name,
    String? status,
    String? objective,
    @JsonKey(name: 'daily_budget') String? dailyBudget,
    @JsonKey(name: 'lifetime_budget') String? lifetimeBudget,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'stop_time') String? stopTime,
    CampaignInsights? insights,
    @JsonKey(name: 'ad_sets') @Default([]) List<dynamic> adSets,
  }) = _MetaCampaign;

  factory MetaCampaign.fromJson(Map<String, dynamic> json) =>
      _$MetaCampaignFromJson(json);
}

@freezed
class MetaAccountOverview with _$MetaAccountOverview {
  const factory MetaAccountOverview({
    MetaAdAccount? account,
    @Default([]) List<MetaCampaign> campaigns,
  }) = _MetaAccountOverview;

  factory MetaAccountOverview.fromJson(Map<String, dynamic> json) =>
      _$MetaAccountOverviewFromJson(json);
}

@freezed
class UpdateCampaignStatusRequest with _$UpdateCampaignStatusRequest {
  const factory UpdateCampaignStatusRequest({
    required String status,
  }) = _UpdateCampaignStatusRequest;

  factory UpdateCampaignStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCampaignStatusRequestFromJson(json);
}

// ==================== Targeting Models ====================

@freezed
class MetaInterest with _$MetaInterest {
  const factory MetaInterest({
    required String id,
    required String name,
    @JsonKey(name: 'audience_size_lower_bound') int? audienceSizeLowerBound,
    @JsonKey(name: 'audience_size_upper_bound') int? audienceSizeUpperBound,
    @Default([]) List<String> path,
  }) = _MetaInterest;

  factory MetaInterest.fromJson(Map<String, dynamic> json) =>
      _$MetaInterestFromJson(json);
}

@freezed
class MetaInterestSearchResponse with _$MetaInterestSearchResponse {
  const factory MetaInterestSearchResponse({
    @Default([]) List<MetaInterest> interests,
  }) = _MetaInterestSearchResponse;

  factory MetaInterestSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$MetaInterestSearchResponseFromJson(json);
}

@freezed
class MetaGeoLocation with _$MetaGeoLocation {
  const factory MetaGeoLocation({
    required String key,
    required String name,
    required String type,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'country_name') String? countryName,
    String? region,
    @JsonKey(name: 'region_id') int? regionId,
    @JsonKey(name: 'supports_city') bool? supportsCity,
    @JsonKey(name: 'supports_region') bool? supportsRegion,
  }) = _MetaGeoLocation;

  factory MetaGeoLocation.fromJson(Map<String, dynamic> json) =>
      _$MetaGeoLocationFromJson(json);
}

@freezed
class MetaGeoSearchResponse with _$MetaGeoSearchResponse {
  const factory MetaGeoSearchResponse({
    @Default([]) List<MetaGeoLocation> locations,
  }) = _MetaGeoSearchResponse;

  factory MetaGeoSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$MetaGeoSearchResponseFromJson(json);
}

// ==================== Draft Models ====================

@freezed
class PublishDraftResponse with _$PublishDraftResponse {
  const factory PublishDraftResponse({
    @JsonKey(name: 'draft_id') String? draftId,
    @JsonKey(name: 'campaign_id') String? campaignId,
    @JsonKey(name: 'adset_id') String? adsetId,
    @JsonKey(name: 'creative_id') String? creativeId,
    @JsonKey(name: 'ad_id') String? adId,
    String? status,
  }) = _PublishDraftResponse;

  factory PublishDraftResponse.fromJson(Map<String, dynamic> json) =>
      _$PublishDraftResponseFromJson(json);
}

// ==================== Leadgen Webhook Models ====================

@freezed
class LeadgenWebhookInfo with _$LeadgenWebhookInfo {
  const factory LeadgenWebhookInfo({
    @JsonKey(name: 'webhook_url') required String webhookUrl,
    @JsonKey(name: 'verify_token') required String verifyToken,
    String? instructions,
  }) = _LeadgenWebhookInfo;

  factory LeadgenWebhookInfo.fromJson(Map<String, dynamic> json) =>
      _$LeadgenWebhookInfoFromJson(json);
}

@freezed
class UpdateVerifyTokenRequest with _$UpdateVerifyTokenRequest {
  const factory UpdateVerifyTokenRequest({
    @JsonKey(name: 'verify_token') required String verifyToken,
  }) = _UpdateVerifyTokenRequest;

  factory UpdateVerifyTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateVerifyTokenRequestFromJson(json);
}

@freezed
class SyncLeadsRequest with _$SyncLeadsRequest {
  const factory SyncLeadsRequest({
    @JsonKey(name: 'form_id') required String formId,
    @JsonKey(name: 'since_timestamp') int? sinceTimestamp,
  }) = _SyncLeadsRequest;

  factory SyncLeadsRequest.fromJson(Map<String, dynamic> json) =>
      _$SyncLeadsRequestFromJson(json);
}

@freezed
class SyncLeadsResponse with _$SyncLeadsResponse {
  const factory SyncLeadsResponse({
    @JsonKey(name: 'form_id') String? formId,
    @Default(0) int fetched,
    @Default(0) int imported,
    @Default(0) int skipped,
    @Default(0) int errors,
  }) = _SyncLeadsResponse;

  factory SyncLeadsResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncLeadsResponseFromJson(json);
}

// ==================== Polling Config Models ====================

@freezed
class PollingConfig with _$PollingConfig {
  const factory PollingConfig({
    required String id,
    @JsonKey(name: 'form_id') required String formId,
    @JsonKey(name: 'form_name') String? formName,
    @JsonKey(name: 'sync_interval_minutes') required int syncIntervalMinutes,
    required String status,
    @JsonKey(name: 'last_sync_at') DateTime? lastSyncAt,
    @JsonKey(name: 'last_sync_result') String? lastSyncResult,
    @JsonKey(name: 'last_error') String? lastError,
    @JsonKey(name: 'total_syncs') @Default(0) int totalSyncs,
    @JsonKey(name: 'total_leads_imported') @Default(0) int totalLeadsImported,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PollingConfig;

  factory PollingConfig.fromJson(Map<String, dynamic> json) =>
      _$PollingConfigFromJson(json);
}

@freezed
class CreatePollingConfigRequest with _$CreatePollingConfigRequest {
  const factory CreatePollingConfigRequest({
    @JsonKey(name: 'form_id') required String formId,
    @JsonKey(name: 'form_name') String? formName,
    @JsonKey(name: 'sync_interval_minutes') @Default(15) int syncIntervalMinutes,
  }) = _CreatePollingConfigRequest;

  factory CreatePollingConfigRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePollingConfigRequestFromJson(json);
}

@freezed
class UpdatePollingConfigRequest with _$UpdatePollingConfigRequest {
  const factory UpdatePollingConfigRequest({
    @JsonKey(name: 'sync_interval_minutes') int? syncIntervalMinutes,
    String? status,
  }) = _UpdatePollingConfigRequest;

  factory UpdatePollingConfigRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePollingConfigRequestFromJson(json);
}

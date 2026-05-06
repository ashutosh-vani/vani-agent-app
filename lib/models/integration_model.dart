class MetaConnection {
  final String id;
  final String userId;
  final String provider;
  final String appId;
  final String appSecret;
  final String accessToken;
  final String? pageId;
  final String? adAccountId;
  final String? instagramActorId;
  final String? businessId;
  final String? pixelId;
  final String? tokenType;
  final DateTime? lastValidatedAt;
  final String? lastValidationError;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  MetaConnection({
    required this.id,
    required this.userId,
    required this.provider,
    required this.appId,
    required this.appSecret,
    required this.accessToken,
    this.pageId,
    this.adAccountId,
    this.instagramActorId,
    this.businessId,
    this.pixelId,
    this.tokenType,
    this.lastValidatedAt,
    this.lastValidationError,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MetaConnection.fromJson(Map<String, dynamic> json) {
    return MetaConnection(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      provider: json['provider'] as String,
      appId: json['app_id'] as String,
      appSecret: json['app_secret'] as String,
      accessToken: json['access_token'] as String,
      pageId: json['page_id'] as String?,
      adAccountId: json['ad_account_id'] as String?,
      instagramActorId: json['instagram_actor_id'] as String?,
      businessId: json['business_id'] as String?,
      pixelId: json['pixel_id'] as String?,
      tokenType: json['token_type'] as String?,
      lastValidatedAt: json['last_validated_at'] != null
          ? DateTime.parse(json['last_validated_at'] as String)
          : null,
      lastValidationError: json['last_validation_error'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider': provider,
      'app_id': appId,
      'app_secret': appSecret,
      'access_token': accessToken,
      if (pageId != null) 'page_id': pageId,
      if (adAccountId != null) 'ad_account_id': adAccountId,
      if (instagramActorId != null) 'instagram_actor_id': instagramActorId,
      if (businessId != null) 'business_id': businessId,
      if (pixelId != null) 'pixel_id': pixelId,
      if (tokenType != null) 'token_type': tokenType,
      if (lastValidatedAt != null)
        'last_validated_at': lastValidatedAt!.toIso8601String(),
      if (lastValidationError != null)
        'last_validation_error': lastValidationError,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class MetaValidationResult {
  final bool valid;
  final String? adAccountId;
  final String? adAccountName;
  final String? pageId;
  final String? pageName;
  final String? message;
  final String? error;

  MetaValidationResult({
    required this.valid,
    this.adAccountId,
    this.adAccountName,
    this.pageId,
    this.pageName,
    this.message,
    this.error,
  });

  factory MetaValidationResult.fromJson(Map<String, dynamic> json) {
    return MetaValidationResult(
      valid: json['valid'] as bool,
      adAccountId: json['ad_account_id'] as String?,
      adAccountName: json['ad_account_name'] as String?,
      pageId: json['page_id'] as String?,
      pageName: json['page_name'] as String?,
      message: json['message'] as String?,
      error: json['error'] as String?,
    );
  }
}

class WhatsAppConnection {
  final String id;
  final String userId;
  final String provider;
  final String businessPhoneId;
  final String apiToken;
  final String? businessAccountId;
  final String? appId;
  final String? appSecret;
  final bool isActive;
  final bool whatsappAgentEnabled;
  final String? whatsappAgentSystemPrompt;
  final DateTime createdAt;
  final DateTime updatedAt;

  WhatsAppConnection({
    required this.id,
    required this.userId,
    required this.provider,
    required this.businessPhoneId,
    required this.apiToken,
    this.businessAccountId,
    this.appId,
    this.appSecret,
    required this.isActive,
    required this.whatsappAgentEnabled,
    this.whatsappAgentSystemPrompt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WhatsAppConnection.fromJson(Map<String, dynamic> json) {
    return WhatsAppConnection(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      provider: json['provider'] as String,
      businessPhoneId: json['business_phone_id'] as String,
      apiToken: json['api_token'] as String,
      businessAccountId: json['business_account_id'] as String?,
      appId: json['app_id'] as String?,
      appSecret: json['app_secret'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      whatsappAgentEnabled: json['whatsapp_agent_enabled'] as bool? ?? false,
      whatsappAgentSystemPrompt:
          json['whatsapp_agent_system_prompt'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider': provider,
      'business_phone_id': businessPhoneId,
      'api_token': apiToken,
      if (businessAccountId != null) 'business_account_id': businessAccountId,
      if (appId != null) 'app_id': appId,
      if (appSecret != null) 'app_secret': appSecret,
      'is_active': isActive,
      'whatsapp_agent_enabled': whatsappAgentEnabled,
      if (whatsappAgentSystemPrompt != null)
        'whatsapp_agent_system_prompt': whatsappAgentSystemPrompt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class WhatsAppValidationResult {
  final bool valid;
  final String? displayPhoneNumber;
  final String? verifiedName;
  final String? qualityRating;
  final String? error;

  WhatsAppValidationResult({
    required this.valid,
    this.displayPhoneNumber,
    this.verifiedName,
    this.qualityRating,
    this.error,
  });

  factory WhatsAppValidationResult.fromJson(Map<String, dynamic> json) {
    return WhatsAppValidationResult(
      valid: json['valid'] as bool,
      displayPhoneNumber: json['display_phone_number'] as String?,
      verifiedName: json['verified_name'] as String?,
      qualityRating: json['quality_rating'] as String?,
      error: json['error'] as String?,
    );
  }
}

class WhatsAppTemplate {
  final String id;
  final String name;
  final String status;
  final String language;
  final String category;
  final List<dynamic> components;

  WhatsAppTemplate({
    required this.id,
    required this.name,
    required this.status,
    required this.language,
    required this.category,
    required this.components,
  });

  factory WhatsAppTemplate.fromJson(Map<String, dynamic> json) {
    return WhatsAppTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      language: json['language'] as String,
      category: json['category'] as String,
      components: json['components'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'language': language,
      'category': category,
      'components': components,
    };
  }
}

class WhatsAppTemplatesResponse {
  final List<WhatsAppTemplate> templates;
  final int total;

  WhatsAppTemplatesResponse({
    required this.templates,
    required this.total,
  });

  factory WhatsAppTemplatesResponse.fromJson(Map<String, dynamic> json) {
    return WhatsAppTemplatesResponse(
      templates: (json['templates'] as List<dynamic>)
          .map((e) => WhatsAppTemplate.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }
}

class CreateMetaConnectionRequest {
  final String appId;
  final String appSecret;
  final String accessToken;
  final String? pageId;
  final String? adAccountId;
  final String? instagramActorId;
  final String? businessId;
  final String? pixelId;
  final String? tokenType;

  CreateMetaConnectionRequest({
    required this.appId,
    required this.appSecret,
    required this.accessToken,
    this.pageId,
    this.adAccountId,
    this.instagramActorId,
    this.businessId,
    this.pixelId,
    this.tokenType,
  });

  Map<String, dynamic> toJson() {
    return {
      'app_id': appId,
      'app_secret': appSecret,
      'access_token': accessToken,
      if (pageId != null) 'page_id': pageId,
      if (adAccountId != null) 'ad_account_id': adAccountId,
      if (instagramActorId != null) 'instagram_actor_id': instagramActorId,
      if (businessId != null) 'business_id': businessId,
      if (pixelId != null) 'pixel_id': pixelId,
      if (tokenType != null) 'token_type': tokenType,
    };
  }
}

class CreateWhatsAppConnectionRequest {
  final String businessPhoneId;
  final String apiToken;
  final String? businessAccountId;
  final String? appId;
  final String? appSecret;

  CreateWhatsAppConnectionRequest({
    required this.businessPhoneId,
    required this.apiToken,
    this.businessAccountId,
    this.appId,
    this.appSecret,
  });

  Map<String, dynamic> toJson() {
    return {
      'business_phone_id': businessPhoneId,
      'api_token': apiToken,
      if (businessAccountId != null) 'business_account_id': businessAccountId,
      if (appId != null) 'app_id': appId,
      if (appSecret != null) 'app_secret': appSecret,
    };
  }
}

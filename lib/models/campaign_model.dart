class Campaign {
  final String id;
  final String userId;
  final String name;
  final String agentId;
  final String agentName;
  final String? contactFileName;
  final String? contactFilePath;
  final String? contactFileUrl;
  final int retries;
  final int maxConcurrentCalls;
  final String? customFirstLine;
  final String? startDateTime;
  final String? endDateTime;
  final String? timeZone;
  final String status;
  final bool autoFollowupEnabled;
  final String? autoFollowupTriggerType;
  final bool smsAutomationEnabled;
  final String? smsTriggerType;
  final String? smsContent;
  final bool whatsappAutomationEnabled;
  final String? whatsappTriggerType;
  final String? whatsappTemplateId;
  final String? whatsappTemplateLanguage;
  final List<String>? whatsappBodyParams;
  final List<String>? whatsappHeaderParams;
  final List<Map<String, dynamic>>? whatsappButtonParams;
  final String? whatsappMediaUrl;
  final String? whatsappMediaType;
  final bool whatsappUseContactData;
  final bool whatsappEscalationEnabled;
  final int whatsappEscalationAfterRound;
  final int whatsappEscalationMaxPerDay;
  final int whatsappEscalationMaxTotal;
  final List<dynamic> phoneNumberIds;
  final String numberRotationStrategy;
  final String campaignType;
  final int callWindowStart;
  final int callWindowEnd;
  final int noAnswerCooldownMinutes;
  final int shortCallThresholdSeconds;
  final int longCallThresholdSeconds;
  final int maxAttemptsPerDay;
  final int maxCampaignDays;
  final int maxQualificationRounds;
  final String? activatedAt;
  final String contactSource;
  final String? gsheetUrl;
  final String? gsheetCsvUrl;
  final String? gsheetColumnPhone;
  final String? gsheetColumnName;
  final String? gsheetColumnInstruction;
  final String? gsheetLastSyncAt;
  final int gsheetSyncIntervalMinutes;
  final String? streamMode;
  final String? streamSourceFilter;
  final String? streamLeadStatusFilter;
  final String? streamLastCheckAt;
  final String createdAt;
  final String updatedAt;

  Campaign({
    required this.id,
    required this.userId,
    required this.name,
    required this.agentId,
    required this.agentName,
    this.contactFileName,
    this.contactFilePath,
    this.contactFileUrl,
    required this.retries,
    required this.maxConcurrentCalls,
    this.customFirstLine,
    this.startDateTime,
    this.endDateTime,
    this.timeZone,
    required this.status,
    required this.autoFollowupEnabled,
    this.autoFollowupTriggerType,
    required this.smsAutomationEnabled,
    this.smsTriggerType,
    this.smsContent,
    required this.whatsappAutomationEnabled,
    this.whatsappTriggerType,
    this.whatsappTemplateId,
    this.whatsappTemplateLanguage,
    this.whatsappBodyParams,
    this.whatsappHeaderParams,
    this.whatsappButtonParams,
    this.whatsappMediaUrl,
    this.whatsappMediaType,
    required this.whatsappUseContactData,
    required this.whatsappEscalationEnabled,
    required this.whatsappEscalationAfterRound,
    required this.whatsappEscalationMaxPerDay,
    required this.whatsappEscalationMaxTotal,
    required this.phoneNumberIds,
    required this.numberRotationStrategy,
    required this.campaignType,
    required this.callWindowStart,
    required this.callWindowEnd,
    required this.noAnswerCooldownMinutes,
    required this.shortCallThresholdSeconds,
    required this.longCallThresholdSeconds,
    required this.maxAttemptsPerDay,
    required this.maxCampaignDays,
    required this.maxQualificationRounds,
    this.activatedAt,
    required this.contactSource,
    this.gsheetUrl,
    this.gsheetCsvUrl,
    this.gsheetColumnPhone,
    this.gsheetColumnName,
    this.gsheetColumnInstruction,
    this.gsheetLastSyncAt,
    required this.gsheetSyncIntervalMinutes,
    this.streamMode,
    this.streamSourceFilter,
    this.streamLeadStatusFilter,
    this.streamLastCheckAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      agentId: json['agent_id'] as String,
      agentName: json['agent_name'] as String,
      contactFileName: json['contact_file_name'] as String?,
      contactFilePath: json['contact_file_path'] as String?,
      contactFileUrl: json['contact_file_url'] as String?,
      retries: json['retries'] as int? ?? 0,
      maxConcurrentCalls: json['max_concurrent_calls'] as int? ?? 0,
      customFirstLine: json['custom_first_line'] as String?,
      startDateTime: json['start_date_time'] as String?,
      endDateTime: json['end_date_time'] as String?,
      timeZone: json['time_zone'] as String?,
      status: json['status'] as String,
      autoFollowupEnabled: json['auto_followup_enabled'] as bool? ?? false,
      autoFollowupTriggerType: json['auto_followup_trigger_type'] as String?,
      smsAutomationEnabled: json['sms_automation_enabled'] as bool? ?? false,
      smsTriggerType: json['sms_trigger_type'] as String?,
      smsContent: json['sms_content'] as String?,
      whatsappAutomationEnabled: json['whatsapp_automation_enabled'] as bool? ?? false,
      whatsappTriggerType: json['whatsapp_trigger_type'] as String?,
      whatsappTemplateId: json['whatsapp_template_id'] as String?,
      whatsappTemplateLanguage: json['whatsapp_template_language'] as String?,
      whatsappBodyParams: (json['whatsapp_body_params'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      whatsappHeaderParams: (json['whatsapp_header_params'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      whatsappButtonParams: (json['whatsapp_button_params'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      whatsappMediaUrl: json['whatsapp_media_url'] as String?,
      whatsappMediaType: json['whatsapp_media_type'] as String?,
      whatsappUseContactData: json['whatsapp_use_contact_data'] as bool? ?? false,
      whatsappEscalationEnabled: json['whatsapp_escalation_enabled'] as bool? ?? false,
      whatsappEscalationAfterRound: json['whatsapp_escalation_after_round'] as int? ?? 3,
      whatsappEscalationMaxPerDay: json['whatsapp_escalation_max_per_day'] as int? ?? 1,
      whatsappEscalationMaxTotal: json['whatsapp_escalation_max_total'] as int? ?? 5,
      phoneNumberIds: json['phone_number_ids'] as List<dynamic>? ?? [],
      numberRotationStrategy: json['number_rotation_strategy'] as String? ?? 'smart',
      campaignType: json['campaign_type'] as String? ?? 'static',
      callWindowStart: json['call_window_start'] as int? ?? 0,
      callWindowEnd: json['call_window_end'] as int? ?? 0,
      noAnswerCooldownMinutes: json['no_answer_cooldown_minutes'] as int? ?? 30,
      shortCallThresholdSeconds: json['short_call_threshold_seconds'] as int? ?? 15,
      longCallThresholdSeconds: json['long_call_threshold_seconds'] as int? ?? 60,
      maxAttemptsPerDay: json['max_attempts_per_day'] as int? ?? 5,
      maxCampaignDays: json['max_campaign_days'] as int? ?? 10,
      maxQualificationRounds: json['max_qualification_rounds'] as int? ?? 5,
      activatedAt: json['activated_at'] as String?,
      contactSource: json['contact_source'] as String? ?? 'file',
      gsheetUrl: json['gsheet_url'] as String?,
      gsheetCsvUrl: json['gsheet_csv_url'] as String?,
      gsheetColumnPhone: json['gsheet_column_phone'] as String?,
      gsheetColumnName: json['gsheet_column_name'] as String?,
      gsheetColumnInstruction: json['gsheet_column_instruction'] as String?,
      gsheetLastSyncAt: json['gsheet_last_sync_at'] as String?,
      gsheetSyncIntervalMinutes: json['gsheet_sync_interval_minutes'] as int? ?? 30,
      streamMode: json['stream_mode'] as String?,
      streamSourceFilter: json['stream_source_filter'] as String?,
      streamLeadStatusFilter: json['stream_lead_status_filter'] as String?,
      streamLastCheckAt: json['stream_last_check_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'agent_id': agentId,
      'agent_name': agentName,
      'contact_file_name': contactFileName,
      'contact_file_path': contactFilePath,
      'contact_file_url': contactFileUrl,
      'retries': retries,
      'max_concurrent_calls': maxConcurrentCalls,
      'custom_first_line': customFirstLine,
      'start_date_time': startDateTime,
      'end_date_time': endDateTime,
      'time_zone': timeZone,
      'status': status,
      'auto_followup_enabled': autoFollowupEnabled,
      'auto_followup_trigger_type': autoFollowupTriggerType,
      'sms_automation_enabled': smsAutomationEnabled,
      'sms_trigger_type': smsTriggerType,
      'sms_content': smsContent,
      'whatsapp_automation_enabled': whatsappAutomationEnabled,
      'whatsapp_trigger_type': whatsappTriggerType,
      'whatsapp_template_id': whatsappTemplateId,
      'whatsapp_template_language': whatsappTemplateLanguage,
      'whatsapp_body_params': whatsappBodyParams,
      'whatsapp_header_params': whatsappHeaderParams,
      'whatsapp_button_params': whatsappButtonParams,
      'whatsapp_media_url': whatsappMediaUrl,
      'whatsapp_media_type': whatsappMediaType,
      'whatsapp_use_contact_data': whatsappUseContactData,
      'whatsapp_escalation_enabled': whatsappEscalationEnabled,
      'whatsapp_escalation_after_round': whatsappEscalationAfterRound,
      'whatsapp_escalation_max_per_day': whatsappEscalationMaxPerDay,
      'whatsapp_escalation_max_total': whatsappEscalationMaxTotal,
      'phone_number_ids': phoneNumberIds,
      'number_rotation_strategy': numberRotationStrategy,
      'campaign_type': campaignType,
      'call_window_start': callWindowStart,
      'call_window_end': callWindowEnd,
      'no_answer_cooldown_minutes': noAnswerCooldownMinutes,
      'short_call_threshold_seconds': shortCallThresholdSeconds,
      'long_call_threshold_seconds': longCallThresholdSeconds,
      'max_attempts_per_day': maxAttemptsPerDay,
      'max_campaign_days': maxCampaignDays,
      'max_qualification_rounds': maxQualificationRounds,
      'activated_at': activatedAt,
      'contact_source': contactSource,
      'gsheet_url': gsheetUrl,
      'gsheet_csv_url': gsheetCsvUrl,
      'gsheet_column_phone': gsheetColumnPhone,
      'gsheet_column_name': gsheetColumnName,
      'gsheet_column_instruction': gsheetColumnInstruction,
      'gsheet_last_sync_at': gsheetLastSyncAt,
      'gsheet_sync_interval_minutes': gsheetSyncIntervalMinutes,
      'stream_mode': streamMode,
      'stream_source_filter': streamSourceFilter,
      'stream_lead_status_filter': streamLeadStatusFilter,
      'stream_last_check_at': streamLastCheckAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

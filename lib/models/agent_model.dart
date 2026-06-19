class Agent {
  final String id;
  final String userId;
  final String name;
  final String? phoneNumberId;
  final String voice;
  final String ttsLanguage;
  final String ttsProvider;
  final String? speechToSpeechProvider;
  final String? geminiLiveVoice;
  final String? geminiLiveLanguage;
  final String greetingType;
  final String? greetingLine;
  final String? agentPrompt;
  final Map<String, dynamic>? s2sPromptConfig;
  final String? localFallbackPrompt;
  final String? analysisPrompt;
  final Map<String, dynamic>? analysisConfig;
  final List<String>? transcriptionLanguages;
  final List<String>? knowledgeBaseIds;
  final double ttsSpeed;
  final bool allowInterruptions;
  final bool backgroundMusic;
  final bool debugLogging;
  final bool isFrozen;
  final double cacheHitRate;
  final int hardEndCallMinutes;
  final bool isActive;
  final bool enableVideoAvatar;
  final String? simliFaceId;
  final String createdAt;
  final String updatedAt;

  Agent({
    required this.id,
    required this.userId,
    required this.name,
    this.phoneNumberId,
    required this.voice,
    required this.ttsLanguage,
    required this.ttsProvider,
    this.speechToSpeechProvider,
    this.geminiLiveVoice,
    this.geminiLiveLanguage,
    this.greetingType = 'fixed',
    this.greetingLine,
    this.agentPrompt,
    this.s2sPromptConfig,
    this.localFallbackPrompt,
    this.analysisPrompt,
    this.analysisConfig,
    this.transcriptionLanguages,
    this.knowledgeBaseIds,
    this.ttsSpeed = 1.0,
    required this.allowInterruptions,
    required this.backgroundMusic,
    required this.debugLogging,
    required this.isFrozen,
    this.cacheHitRate = 0,
    required this.hardEndCallMinutes,
    required this.isActive,
    this.enableVideoAvatar = false,
    this.simliFaceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumberId: json['phone_number_id'] as String?,
      voice: json['voice'] as String? ?? '',
      ttsLanguage: json['tts_language'] as String? ?? '',
      ttsProvider: json['tts_provider'] as String? ?? '',
      speechToSpeechProvider: json['speech_to_speech_provider'] as String?,
      geminiLiveVoice: json['gemini_live_voice'] as String?,
      geminiLiveLanguage: json['gemini_live_language'] as String?,
      greetingType: json['greeting_type'] as String? ?? 'fixed',
      greetingLine: json['greeting_line'] as String?,
      agentPrompt: json['agent_prompt'] as String?,
      s2sPromptConfig: json['s2s_prompt_config'] as Map<String, dynamic>?,
      localFallbackPrompt: json['local_fallback_prompt'] as String?,
      analysisPrompt: json['analysis_prompt'] as String?,
      analysisConfig: json['analysis_config'] as Map<String, dynamic>?,
      transcriptionLanguages: (json['transcription_languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      knowledgeBaseIds: (json['knowledge_base_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      ttsSpeed: (json['tts_speed'] as num?)?.toDouble() ?? 1.0,
      allowInterruptions: json['allow_interruptions'] as bool? ?? false,
      backgroundMusic: json['background_music'] as bool? ?? false,
      debugLogging: json['debug_logging'] as bool? ?? false,
      isFrozen: json['is_frozen'] as bool? ?? false,
      cacheHitRate: (json['cache_hit_rate'] as num?)?.toDouble() ?? 0,
      hardEndCallMinutes: json['hard_end_call_minutes'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? false,
      enableVideoAvatar: json['enable_video_avatar'] as bool? ?? false,
      simliFaceId: json['simli_face_id'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone_number_id': phoneNumberId,
      'voice': voice,
      'tts_language': ttsLanguage,
      'tts_provider': ttsProvider,
      'speech_to_speech_provider': speechToSpeechProvider,
      'gemini_live_voice': geminiLiveVoice,
      'gemini_live_language': geminiLiveLanguage,
      'greeting_type': greetingType,
      'greeting_line': greetingLine,
      'agent_prompt': agentPrompt,
      's2s_prompt_config': s2sPromptConfig,
      'local_fallback_prompt': localFallbackPrompt,
      'analysis_prompt': analysisPrompt,
      'analysis_config': analysisConfig,
      'transcription_languages': transcriptionLanguages,
      'knowledge_base_ids': knowledgeBaseIds,
      'tts_speed': ttsSpeed,
      'allow_interruptions': allowInterruptions,
      'background_music': backgroundMusic,
      'debug_logging': debugLogging,
      'is_frozen': isFrozen,
      'cache_hit_rate': cacheHitRate,
      'hard_end_call_minutes': hardEndCallMinutes,
      'is_active': isActive,
      'enable_video_avatar': enableVideoAvatar,
      'simli_face_id': simliFaceId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Agent copyWith({
    String? id,
    String? userId,
    String? name,
    String? phoneNumberId,
    String? voice,
    String? ttsLanguage,
    String? ttsProvider,
    String? speechToSpeechProvider,
    String? geminiLiveVoice,
    String? geminiLiveLanguage,
    String? greetingType,
    String? greetingLine,
    String? agentPrompt,
    Map<String, dynamic>? s2sPromptConfig,
    String? localFallbackPrompt,
    String? analysisPrompt,
    Map<String, dynamic>? analysisConfig,
    List<String>? transcriptionLanguages,
    List<String>? knowledgeBaseIds,
    double? ttsSpeed,
    bool? allowInterruptions,
    bool? backgroundMusic,
    bool? debugLogging,
    bool? isFrozen,
    double? cacheHitRate,
    int? hardEndCallMinutes,
    bool? isActive,
    bool? enableVideoAvatar,
    String? simliFaceId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Agent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phoneNumberId: phoneNumberId ?? this.phoneNumberId,
      voice: voice ?? this.voice,
      ttsLanguage: ttsLanguage ?? this.ttsLanguage,
      ttsProvider: ttsProvider ?? this.ttsProvider,
      speechToSpeechProvider: speechToSpeechProvider ?? this.speechToSpeechProvider,
      geminiLiveVoice: geminiLiveVoice ?? this.geminiLiveVoice,
      geminiLiveLanguage: geminiLiveLanguage ?? this.geminiLiveLanguage,
      greetingType: greetingType ?? this.greetingType,
      greetingLine: greetingLine ?? this.greetingLine,
      agentPrompt: agentPrompt ?? this.agentPrompt,
      s2sPromptConfig: s2sPromptConfig ?? this.s2sPromptConfig,
      localFallbackPrompt: localFallbackPrompt ?? this.localFallbackPrompt,
      analysisPrompt: analysisPrompt ?? this.analysisPrompt,
      analysisConfig: analysisConfig ?? this.analysisConfig,
      transcriptionLanguages: transcriptionLanguages ?? this.transcriptionLanguages,
      knowledgeBaseIds: knowledgeBaseIds ?? this.knowledgeBaseIds,
      ttsSpeed: ttsSpeed ?? this.ttsSpeed,
      allowInterruptions: allowInterruptions ?? this.allowInterruptions,
      backgroundMusic: backgroundMusic ?? this.backgroundMusic,
      debugLogging: debugLogging ?? this.debugLogging,
      isFrozen: isFrozen ?? this.isFrozen,
      cacheHitRate: cacheHitRate ?? this.cacheHitRate,
      hardEndCallMinutes: hardEndCallMinutes ?? this.hardEndCallMinutes,
      isActive: isActive ?? this.isActive,
      enableVideoAvatar: enableVideoAvatar ?? this.enableVideoAvatar,
      simliFaceId: simliFaceId ?? this.simliFaceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

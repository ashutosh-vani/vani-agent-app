class Agent {
  final String id;
  final String userId;
  final String name;
  final String? phoneNumberId;
  final String voice;
  final String ttsLanguage;
  final String ttsProvider;
  final String? greetingLine;
  final String? agentPrompt;
  final String? analysisPrompt;
  final Map<String, dynamic>? analysisConfig;
  final List<String>? transcriptionLanguages;
  final List<String>? knowledgeBaseIds;
  final bool allowInterruptions;
  final bool backgroundMusic;
  final bool debugLogging;
  final bool isFrozen;
  final int hardEndCallMinutes;
  final bool isActive;
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
    this.greetingLine,
    this.agentPrompt,
    this.analysisPrompt,
    this.analysisConfig,
    this.transcriptionLanguages,
    this.knowledgeBaseIds,
    required this.allowInterruptions,
    required this.backgroundMusic,
    required this.debugLogging,
    required this.isFrozen,
    required this.hardEndCallMinutes,
    required this.isActive,
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
      greetingLine: json['greeting_line'] as String?,
      agentPrompt: json['agent_prompt'] as String?,
      analysisPrompt: json['analysis_prompt'] as String?,
      analysisConfig: json['analysis_config'] as Map<String, dynamic>?,
      transcriptionLanguages: (json['transcription_languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      knowledgeBaseIds: (json['knowledge_base_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      allowInterruptions: json['allow_interruptions'] as bool? ?? false,
      backgroundMusic: json['background_music'] as bool? ?? false,
      debugLogging: json['debug_logging'] as bool? ?? false,
      isFrozen: json['is_frozen'] as bool? ?? false,
      hardEndCallMinutes: json['hard_end_call_minutes'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? false,
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
      'greeting_line': greetingLine,
      'agent_prompt': agentPrompt,
      'analysis_prompt': analysisPrompt,
      'analysis_config': analysisConfig,
      'transcription_languages': transcriptionLanguages,
      'knowledge_base_ids': knowledgeBaseIds,
      'allow_interruptions': allowInterruptions,
      'background_music': backgroundMusic,
      'debug_logging': debugLogging,
      'is_frozen': isFrozen,
      'hard_end_call_minutes': hardEndCallMinutes,
      'is_active': isActive,
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
    String? greetingLine,
    String? agentPrompt,
    String? analysisPrompt,
    Map<String, dynamic>? analysisConfig,
    List<String>? transcriptionLanguages,
    List<String>? knowledgeBaseIds,
    bool? allowInterruptions,
    bool? backgroundMusic,
    bool? debugLogging,
    bool? isFrozen,
    int? hardEndCallMinutes,
    bool? isActive,
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
      greetingLine: greetingLine ?? this.greetingLine,
      agentPrompt: agentPrompt ?? this.agentPrompt,
      analysisPrompt: analysisPrompt ?? this.analysisPrompt,
      analysisConfig: analysisConfig ?? this.analysisConfig,
      transcriptionLanguages: transcriptionLanguages ?? this.transcriptionLanguages,
      knowledgeBaseIds: knowledgeBaseIds ?? this.knowledgeBaseIds,
      allowInterruptions: allowInterruptions ?? this.allowInterruptions,
      backgroundMusic: backgroundMusic ?? this.backgroundMusic,
      debugLogging: debugLogging ?? this.debugLogging,
      isFrozen: isFrozen ?? this.isFrozen,
      hardEndCallMinutes: hardEndCallMinutes ?? this.hardEndCallMinutes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

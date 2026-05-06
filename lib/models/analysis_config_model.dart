class AnalysisConfigSuggestion {
  final String sentimentRules;
  final String outcomeGuidance;
  final String keyPointsGuidance;
  final String actionItemsGuidance;
  final List<CustomFieldSuggestion> suggestedCustomFields;

  AnalysisConfigSuggestion({
    required this.sentimentRules,
    required this.outcomeGuidance,
    required this.keyPointsGuidance,
    required this.actionItemsGuidance,
    required this.suggestedCustomFields,
  });

  factory AnalysisConfigSuggestion.fromJson(Map<String, dynamic> json) {
    return AnalysisConfigSuggestion(
      sentimentRules: json['sentiment_rules'] as String? ?? '',
      outcomeGuidance: json['outcome_guidance'] as String? ?? '',
      keyPointsGuidance: json['key_points_guidance'] as String? ?? '',
      actionItemsGuidance: json['action_items_guidance'] as String? ?? '',
      suggestedCustomFields: (json['suggested_custom_fields'] as List<dynamic>?)
              ?.map((e) => CustomFieldSuggestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentiment_rules': sentimentRules,
      'outcome_guidance': outcomeGuidance,
      'key_points_guidance': keyPointsGuidance,
      'action_items_guidance': actionItemsGuidance,
      'suggested_custom_fields': suggestedCustomFields.map((e) => e.toJson()).toList(),
    };
  }
}

class CustomFieldSuggestion {
  final String name;
  final String type;
  final String description;

  CustomFieldSuggestion({
    required this.name,
    required this.type,
    required this.description,
  });

  factory CustomFieldSuggestion.fromJson(Map<String, dynamic> json) {
    return CustomFieldSuggestion(
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
    };
  }
}

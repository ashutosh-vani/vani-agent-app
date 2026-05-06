enum LeadStatus {
  newLead('New'),
  attempting('Attempting'),
  connected('Connected'),
  interested('Interested'),
  qualified('Qualified'),
  converted('Converted'),
  notInterested('Not Interested'),
  junkDnc('Junk/DNC');

  final String displayName;
  const LeadStatus(this.displayName);

  static LeadStatus fromString(String? value) {
    if (value == null) return LeadStatus.newLead;
    switch (value.toLowerCase()) {
      case 'new':
        return LeadStatus.newLead;
      case 'attempting':
        return LeadStatus.attempting;
      case 'connected':
        return LeadStatus.connected;
      case 'interested':
        return LeadStatus.interested;
      case 'qualified':
        return LeadStatus.qualified;
      case 'converted':
        return LeadStatus.converted;
      case 'not_interested':
      case 'not interested':
        return LeadStatus.notInterested;
      case 'junk':
      case 'dnc':
      case 'junk/dnc':
      case 'junk_dnc':
        return LeadStatus.junkDnc;
      default:
        return LeadStatus.newLead;
    }
  }

  String toApiString() {
    switch (this) {
      case LeadStatus.newLead:
        return 'new';
      case LeadStatus.attempting:
        return 'attempting';
      case LeadStatus.connected:
        return 'connected';
      case LeadStatus.interested:
        return 'interested';
      case LeadStatus.qualified:
        return 'qualified';
      case LeadStatus.converted:
        return 'converted';
      case LeadStatus.notInterested:
        return 'not_interested';
      case LeadStatus.junkDnc:
        return 'junk_dnc';
    }
  }
}

class WhatsAppConversation {
  final String id;
  final String contactNumber;
  final String connectionId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final bool inFreeWindow;
  final bool aiEnabled;
  final int messageCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LeadStatus leadStatus;
  final List<String> tags;

  WhatsAppConversation({
    required this.id,
    required this.contactNumber,
    required this.connectionId,
    this.lastMessage,
    this.lastMessageAt,
    required this.inFreeWindow,
    required this.aiEnabled,
    required this.messageCount,
    required this.createdAt,
    required this.updatedAt,
    this.leadStatus = LeadStatus.newLead,
    this.tags = const [],
  });

  factory WhatsAppConversation.fromJson(Map<String, dynamic> json) {
    return WhatsAppConversation(
      id: json['id'] as String,
      contactNumber: json['contact_number'] as String,
      connectionId: json['connection_id'] as String,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      inFreeWindow: json['in_free_window'] as bool? ?? false,
      aiEnabled: json['ai_enabled'] as bool? ?? false,
      messageCount: json['message_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      leadStatus: LeadStatus.fromString(json['lead_status'] as String?),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contact_number': contactNumber,
      'connection_id': connectionId,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'in_free_window': inFreeWindow,
      'ai_enabled': aiEnabled,
      'message_count': messageCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'lead_status': leadStatus.toApiString(),
      'tags': tags,
    };
  }

  String get displayNumber {
    // Format phone number for display
    if (contactNumber.startsWith('+')) {
      return contactNumber;
    }
    return '+$contactNumber';
  }

  String get initials {
    // Get initials from phone number (last 2 digits)
    return contactNumber.substring(contactNumber.length - 2);
  }

  WhatsAppConversation copyWith({
    String? id,
    String? contactNumber,
    String? connectionId,
    String? lastMessage,
    DateTime? lastMessageAt,
    bool? inFreeWindow,
    bool? aiEnabled,
    int? messageCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    LeadStatus? leadStatus,
    List<String>? tags,
  }) {
    return WhatsAppConversation(
      id: id ?? this.id,
      contactNumber: contactNumber ?? this.contactNumber,
      connectionId: connectionId ?? this.connectionId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      inFreeWindow: inFreeWindow ?? this.inFreeWindow,
      aiEnabled: aiEnabled ?? this.aiEnabled,
      messageCount: messageCount ?? this.messageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      leadStatus: leadStatus ?? this.leadStatus,
      tags: tags ?? this.tags,
    );
  }
}

class WhatsAppConversationDetail {
  final String id;
  final String contactNumber;
  final String connectionId;
  final List<Map<String, dynamic>> messages;
  final DateTime? lastInboundAt;
  final bool inFreeWindow;
  final bool aiEnabled;
  final String? aiSystemPrompt;
  final DateTime createdAt;
  final DateTime updatedAt;

  WhatsAppConversationDetail({
    required this.id,
    required this.contactNumber,
    required this.connectionId,
    required this.messages,
    this.lastInboundAt,
    required this.inFreeWindow,
    required this.aiEnabled,
    this.aiSystemPrompt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WhatsAppConversationDetail.fromJson(Map<String, dynamic> json) {
    return WhatsAppConversationDetail(
      id: json['id'] as String,
      contactNumber: json['contact_number'] as String,
      connectionId: json['connection_id'] as String,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      lastInboundAt: json['last_inbound_at'] != null
          ? DateTime.parse(json['last_inbound_at'] as String)
          : null,
      inFreeWindow: json['in_free_window'] as bool? ?? false,
      aiEnabled: json['ai_enabled'] as bool? ?? false,
      aiSystemPrompt: json['ai_system_prompt'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contact_number': contactNumber,
      'connection_id': connectionId,
      'messages': messages,
      'last_inbound_at': lastInboundAt?.toIso8601String(),
      'in_free_window': inFreeWindow,
      'ai_enabled': aiEnabled,
      'ai_system_prompt': aiSystemPrompt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayNumber {
    // Format phone number for display
    if (contactNumber.startsWith('+')) {
      return contactNumber;
    }
    return '+$contactNumber';
  }

  String get initials {
    // Get initials from phone number (last 2 digits)
    return contactNumber.substring(contactNumber.length - 2);
  }
}

class SendMessageRequest {
  final String messageType;
  final String? text;
  final String? templateName;
  final String? languageCode;
  final List<String>? bodyParams;
  final List<String>? headerParams;
  final String? headerMediaUrl;
  final String? headerMediaType;
  final List<Map<String, dynamic>>? buttonParams;
  final String? documentUrl;
  final String? fileName;
  final String? caption;

  SendMessageRequest({
    required this.messageType,
    this.text,
    this.templateName,
    this.languageCode,
    this.bodyParams,
    this.headerParams,
    this.headerMediaUrl,
    this.headerMediaType,
    this.buttonParams,
    this.documentUrl,
    this.fileName,
    this.caption,
  });

  Map<String, dynamic> toJson() {
    return {
      'message_type': messageType,
      if (text != null) 'text': text,
      if (templateName != null) 'template_name': templateName,
      if (languageCode != null) 'language_code': languageCode,
      if (bodyParams != null) 'body_params': bodyParams,
      if (headerParams != null) 'header_params': headerParams,
      if (headerMediaUrl != null) 'header_media_url': headerMediaUrl,
      if (headerMediaType != null) 'header_media_type': headerMediaType,
      if (buttonParams != null) 'button_params': buttonParams,
      if (documentUrl != null) 'document_url': documentUrl,
      if (fileName != null) 'file_name': fileName,
      if (caption != null) 'caption': caption,
    };
  }
}

class WhatsAppIntegrationStatus {
  final bool hasIntegration;
  final String? connectionId;
  final String? phoneNumber;

  WhatsAppIntegrationStatus({
    required this.hasIntegration,
    this.connectionId,
    this.phoneNumber,
  });

  factory WhatsAppIntegrationStatus.fromJson(Map<String, dynamic> json) {
    return WhatsAppIntegrationStatus(
      hasIntegration: json['has_integration'] as bool? ?? false,
      connectionId: json['connection_id'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }
}

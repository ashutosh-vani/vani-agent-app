class CampaignNumber {
  final String id;
  final String phoneNumber;
  final String? contactName;
  final String status;
  final int attempts;
  final bool resolved;
  final String? sentiment;
  final bool whatsappSent;
  final String? cooldownUntil;
  final String? skipUntilDate;
  final int dailyCallCount;
  final String? lastCallAt;
  final String? blocker;
  final String? callOutcome;
  final int qualificationRounds;
  final int triedNumbersCount;
  final int whatsappEscalationCount;
  final String? lastCalledFromNumber;
  final String createdAt;

  CampaignNumber({
    required this.id,
    required this.phoneNumber,
    this.contactName,
    required this.status,
    required this.attempts,
    required this.resolved,
    this.sentiment,
    required this.whatsappSent,
    this.cooldownUntil,
    this.skipUntilDate,
    required this.dailyCallCount,
    this.lastCallAt,
    this.blocker,
    this.callOutcome,
    required this.qualificationRounds,
    required this.triedNumbersCount,
    required this.whatsappEscalationCount,
    this.lastCalledFromNumber,
    required this.createdAt,
  });

  factory CampaignNumber.fromJson(Map<String, dynamic> json) {
    return CampaignNumber(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String,
      contactName: json['contact_name'] as String?,
      status: json['status'] as String,
      attempts: json['attempts'] as int? ?? 0,
      resolved: json['resolved'] as bool? ?? false,
      sentiment: json['sentiment'] as String?,
      whatsappSent: json['whatsapp_sent'] as bool? ?? false,
      cooldownUntil: json['cooldown_until'] as String?,
      skipUntilDate: json['skip_until_date'] as String?,
      dailyCallCount: json['daily_call_count'] as int? ?? 0,
      lastCallAt: json['last_call_at'] as String?,
      blocker: json['blocker'] as String?,
      callOutcome: json['call_outcome'] as String?,
      qualificationRounds: json['qualification_rounds'] as int? ?? 0,
      triedNumbersCount: json['tried_numbers_count'] as int? ?? 0,
      whatsappEscalationCount: json['whatsapp_escalation_count'] as int? ?? 0,
      lastCalledFromNumber: json['last_called_from_number'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'contact_name': contactName,
      'status': status,
      'attempts': attempts,
      'resolved': resolved,
      'sentiment': sentiment,
      'whatsapp_sent': whatsappSent,
      'cooldown_until': cooldownUntil,
      'skip_until_date': skipUntilDate,
      'daily_call_count': dailyCallCount,
      'last_call_at': lastCallAt,
      'blocker': blocker,
      'call_outcome': callOutcome,
      'qualification_rounds': qualificationRounds,
      'tried_numbers_count': triedNumbersCount,
      'whatsapp_escalation_count': whatsappEscalationCount,
      'last_called_from_number': lastCalledFromNumber,
      'created_at': createdAt,
    };
  }
}

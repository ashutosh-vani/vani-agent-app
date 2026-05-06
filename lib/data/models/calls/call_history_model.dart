import 'package:json_annotation/json_annotation.dart';

part 'call_history_model.g.dart';

@JsonSerializable()
class CallHistoryModel {
  final String id;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'call_type')
  final String? callType;
  @JsonKey(name: 'campaign_id')
  final String? campaignId;
  @JsonKey(name: 'campaign_name')
  final String? campaignName;
  @JsonKey(name: 'duration_seconds')
  final int? durationSeconds;
  final String? cost;
  @JsonKey(name: 'rate_per_minute')
  final String? ratePerMinute;
  final String? status;
  @JsonKey(name: 'started_at')
  final String? startedAt;
  @JsonKey(name: 'ended_at')
  final String? endedAt;
  final String? transcript;
  final String? summary;
  final String? sentiment;
  @JsonKey(name: 'json_output')
  final String? jsonOutput;
  @JsonKey(name: 'amd_result')
  final String? amdResult;
  @JsonKey(name: 'provider_recording_url')
  final String? providerRecordingUrl;
  @JsonKey(name: 's3_recording_url')
  final String? s3RecordingUrl;
  @JsonKey(name: 'human_notes_tags')
  final List<String>? humanNotesTags;
  @JsonKey(name: 'human_notes_text')
  final String? humanNotesText;
  @JsonKey(name: 'human_notes_count')
  final int? humanNotesCount;
  @JsonKey(name: 'recording_available')
  final bool? recordingAvailable;

  CallHistoryModel({
    required this.id,
    this.phoneNumber,
    this.callType,
    this.campaignId,
    this.campaignName,
    this.durationSeconds,
    this.cost,
    this.ratePerMinute,
    this.status,
    this.startedAt,
    this.endedAt,
    this.transcript,
    this.summary,
    this.sentiment,
    this.jsonOutput,
    this.amdResult,
    this.providerRecordingUrl,
    this.s3RecordingUrl,
    this.humanNotesTags,
    this.humanNotesText,
    this.humanNotesCount,
    this.recordingAvailable,
  });

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$CallHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CallHistoryModelToJson(this);
}

@JsonSerializable()
class CallHistoryResponse {
  final List<CallHistoryModel> calls;
  final int total;
  final int page;
  final int pages;

  CallHistoryResponse({
    required this.calls,
    required this.total,
    required this.page,
    required this.pages,
  });

  factory CallHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CallHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CallHistoryResponseToJson(this);
}

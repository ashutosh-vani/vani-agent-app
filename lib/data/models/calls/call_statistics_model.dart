import 'package:json_annotation/json_annotation.dart';

part 'call_statistics_model.g.dart';

@JsonSerializable()
class CallStatisticsModel {
  @JsonKey(name: 'total_calls')
  final int totalCalls;
  
  @JsonKey(name: 'total_minutes')
  final String totalMinutes;
  
  @JsonKey(name: 'total_credits_spent')
  final String totalCreditsSpent;
  
  @JsonKey(name: 'average_duration_seconds')
  final int averageDurationSeconds;
  
  @JsonKey(name: 'calls_by_type')
  final Map<String, int>? callsByType;
  
  @JsonKey(name: 'calls_by_status')
  final Map<String, int>? callsByStatus;

  CallStatisticsModel({
    required this.totalCalls,
    required this.totalMinutes,
    required this.totalCreditsSpent,
    required this.averageDurationSeconds,
    this.callsByType,
    this.callsByStatus,
  });

  factory CallStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$CallStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CallStatisticsModelToJson(this);
  
  // Helper getters
  double get totalMinutesAsDouble => double.tryParse(totalMinutes) ?? 0.0;
  double get totalCreditsSpentAsDouble => double.tryParse(totalCreditsSpent) ?? 0.0;
}

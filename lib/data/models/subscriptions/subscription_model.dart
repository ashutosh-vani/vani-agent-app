import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionTierModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? billingPeriod; // 'monthly', 'yearly'
  final Map<String, dynamic>? features;
  final int? callMinutes;
  final int? phoneNumbers;
  final bool? isPopular;

  SubscriptionTierModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.billingPeriod,
    this.features,
    this.callMinutes,
    this.phoneNumbers,
    this.isPopular,
  });

  factory SubscriptionTierModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTierModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionTierModelToJson(this);
}

@JsonSerializable()
class CurrentSubscriptionModel {
  final String? id;
  final String? tierId;
  final String? tierName;
  final String? status; // 'active', 'cancelled', 'expired'
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final int? remainingMinutes;
  final bool? autoRenew;

  CurrentSubscriptionModel({
    this.id,
    this.tierId,
    this.status,
    this.tierName,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.remainingMinutes,
    this.autoRenew,
  });

  factory CurrentSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentSubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentSubscriptionModelToJson(this);
}

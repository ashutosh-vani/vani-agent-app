import 'package:json_annotation/json_annotation.dart';

part 'credits_model.g.dart';

@JsonSerializable()
class CreditBalanceModel {
  final double balance;
  final String currency;
  @JsonKey(name: 'last_updated')
  final DateTime? lastUpdated;

  CreditBalanceModel({
    required this.balance,
    required this.currency,
    this.lastUpdated,
  });

  factory CreditBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$CreditBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreditBalanceModelToJson(this);
}

@JsonSerializable()
class CreditTransactionModel {
  final String id;
  final double amount;
  final String type; // 'purchase', 'usage', 'refund'
  final String description;
  final DateTime timestamp;
  final String? reference;

  CreditTransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.timestamp,
    this.reference,
  });

  factory CreditTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$CreditTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreditTransactionModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'phone_number_model.g.dart';

@JsonSerializable()
class PhoneNumberModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? provider;
  @JsonKey(name: 'provider_connection_id')
  final String? providerConnectionId;
  @JsonKey(name: 'sip_trunk_id')
  final String? sipTrunkId;
  @JsonKey(name: 'date_purchased')
  final String? datePurchased;
  final double? price;
  @JsonKey(name: 'kyc_status')
  final String? kycStatus;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'is_demo')
  final bool? isDemo;
  @JsonKey(name: 'inbound_agent_id')
  final String? inboundAgentId;
  @JsonKey(name: 'supports_outbound')
  final bool? supportsOutbound;
  @JsonKey(name: 'supports_inbound')
  final bool? supportsInbound;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  PhoneNumberModel({
    required this.id,
    this.userId,
    this.phoneNumber,
    this.provider,
    this.providerConnectionId,
    this.sipTrunkId,
    this.datePurchased,
    this.price,
    this.kycStatus,
    this.isActive,
    this.isDemo,
    this.inboundAgentId,
    this.supportsOutbound,
    this.supportsInbound,
    this.createdAt,
    this.updatedAt,
  });

  factory PhoneNumberModel.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneNumberModelToJson(this);
}

@JsonSerializable()
class AvailablePhoneNumberModel {
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'friendly_name')
  final String? friendlyName;
  final String? region;
  @JsonKey(name: 'number_type')
  final String? numberType;
  @JsonKey(name: 'rental_price')
  final String? rentalPrice;
  @JsonKey(name: 'one_time_price')
  final String? oneTimePrice;

  AvailablePhoneNumberModel({
    this.phoneNumber,
    this.friendlyName,
    this.region,
    this.numberType,
    this.rentalPrice,
    this.oneTimePrice,
  });

  factory AvailablePhoneNumberModel.fromJson(Map<String, dynamic> json) =>
      _$AvailablePhoneNumberModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvailablePhoneNumberModelToJson(this);
}

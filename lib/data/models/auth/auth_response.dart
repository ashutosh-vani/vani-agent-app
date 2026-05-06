import 'package:json_annotation/json_annotation.dart';
import 'package:vani_app/data/models/user/user_model.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  @JsonKey(defaultValue: null)
  final UserModel? user;
  final String? message;
  
  // Additional fields that might come from backend
  final String? id;
  final String? email;
  final String? name;
  final String? phone;
  final bool? emailVerified;
  final bool? phoneVerified;
  final String? subscriptionTier;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.message,
    this.id,
    this.email,
    this.name,
    this.phone,
    this.emailVerified,
    this.phoneVerified,
    this.subscriptionTier,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final response = _$AuthResponseFromJson(json);
    
    // If user is null but we have user data at top level, create a UserModel
    if (response.user == null && response.email != null) {
      return response.copyWith(
        user: UserModel(
          id: response.id ?? '',
          email: response.email ?? '',
          name: response.name,
          phone: response.phone,
          emailVerified: response.emailVerified,
          phoneVerified: response.phoneVerified,
          subscriptionTier: response.subscriptionTier,
        ),
      );
    }
    
    return response;
  }

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  AuthResponse copyWith({
    String? accessToken,
    String? refreshToken,
    UserModel? user,
    String? message,
    String? id,
    String? email,
    String? name,
    String? phone,
    bool? emailVerified,
    bool? phoneVerified,
    String? subscriptionTier,
  }) {
    return AuthResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      message: message ?? this.message,
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
    );
  }
}

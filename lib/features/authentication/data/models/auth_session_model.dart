import 'package:fotolou/features/authentication/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_session_model.g.dart';

@JsonSerializable()
class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return _$AuthSessionModelFromJson(json);
  }

  final UserModel user;
  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() {
    return _$AuthSessionModelToJson(this);
  }
}

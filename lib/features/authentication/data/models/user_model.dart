import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';
import 'package:fotolou/features/authentication/domain/entities/user_role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.client,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return _$UserModelToJson(this);
  }
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      role: role,
      createdAt: createdAt,
    );
  }
}

extension UserEntityMapper on UserEntity {
  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      name: name,
      role: role,
      createdAt: createdAt,
    );
  }
}

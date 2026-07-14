import 'package:equatable/equatable.dart';
import 'package:fotolou/features/authentication/domain/entities/user_role.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.client,
    this.createdAt,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, email, name, role, createdAt];
}

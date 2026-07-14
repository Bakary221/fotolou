import 'package:equatable/equatable.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, success, empty, error }

class AuthState extends Equatable {
  const AuthState({required this.status, this.user, this.message});

  const AuthState.initial()
    : status = AuthStatus.initial,
      user = null,
      message = null;

  final AuthStatus status;
  final UserEntity? user;
  final String? message;

  bool get isAuthenticated => status == AuthStatus.success && user != null;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? message,
    bool clearUser = false,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}

import 'package:equatable/equatable.dart';
import 'package:fotolou/core/failures/failure.dart';
import 'package:fotolou/core/usecases/usecase.dart';
import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/core/validators/app_validators.dart';
import 'package:fotolou/features/authentication/domain/entities/login_credentials.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';
import 'package:fotolou/features/authentication/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(LoginParams params) {
    final emailError = AppValidators.email(params.email);
    final passwordError = AppValidators.password(params.password);

    if (emailError != null || passwordError != null) {
      return Future.value(
        ResultFailure<UserEntity>(
          ValidationFailure(emailError ?? passwordError!),
        ),
      );
    }

    return _repository.login(
      LoginCredentials(email: params.email, password: params.password),
    );
  }
}

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

import 'package:fotolou/core/usecases/usecase.dart';
import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';
import 'package:fotolou/features/authentication/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}

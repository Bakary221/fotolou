import 'package:fotolou/core/usecases/usecase.dart';
import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/features/authentication/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.logout();
  }
}

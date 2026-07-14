import 'package:equatable/equatable.dart';
import 'package:fotolou/core/failures/failure.dart';
import 'package:fotolou/core/usecases/usecase.dart';
import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/core/validators/app_validators.dart';
import 'package:fotolou/features/authentication/domain/repositories/auth_repository.dart';

class RequestPhoneOtpUseCase implements UseCase<void, RequestPhoneOtpParams> {
  const RequestPhoneOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(RequestPhoneOtpParams params) {
    final phoneError = AppValidators.phone(params.phone);
    if (phoneError != null) {
      return Future.value(ResultFailure<void>(ValidationFailure(phoneError)));
    }

    return _repository.requestPhoneOtp(params.phone);
  }
}

class RequestPhoneOtpParams extends Equatable {
  const RequestPhoneOtpParams({required this.phone});

  final String phone;

  @override
  List<Object?> get props => [phone];
}

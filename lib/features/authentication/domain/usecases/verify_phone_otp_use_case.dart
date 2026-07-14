import 'package:equatable/equatable.dart';
import 'package:fotolou/core/failures/failure.dart';
import 'package:fotolou/core/usecases/usecase.dart';
import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/core/validators/app_validators.dart';
import 'package:fotolou/features/authentication/domain/entities/phone_otp_credentials.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';
import 'package:fotolou/features/authentication/domain/repositories/auth_repository.dart';

class VerifyPhoneOtpUseCase
    implements UseCase<UserEntity, VerifyPhoneOtpParams> {
  const VerifyPhoneOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(VerifyPhoneOtpParams params) {
    final phoneError = AppValidators.phone(params.phone);
    final otpError = AppValidators.otp(params.otp);

    if (phoneError != null || otpError != null) {
      return Future.value(
        ResultFailure<UserEntity>(ValidationFailure(phoneError ?? otpError!)),
      );
    }

    return _repository.verifyPhoneOtp(
      PhoneOtpCredentials(phone: params.phone, otp: params.otp),
    );
  }
}

class VerifyPhoneOtpParams extends Equatable {
  const VerifyPhoneOtpParams({required this.phone, required this.otp});

  final String phone;
  final String otp;

  @override
  List<Object?> get props => [phone, otp];
}

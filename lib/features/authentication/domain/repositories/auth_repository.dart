import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/features/authentication/domain/entities/login_credentials.dart';
import 'package:fotolou/features/authentication/domain/entities/phone_otp_credentials.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> login(LoginCredentials credentials);
  Future<Result<void>> requestPhoneOtp(String phone);
  Future<Result<UserEntity>> verifyPhoneOtp(PhoneOtpCredentials credentials);
  Future<Result<void>> logout();
  Future<Result<UserEntity?>> getCurrentUser();
}

import 'package:fotolou/core/errors/result_guard.dart';
import 'package:fotolou/core/utils/result.dart';
import 'package:fotolou/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:fotolou/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:fotolou/features/authentication/data/models/login_request_dto.dart';
import 'package:fotolou/features/authentication/data/models/phone_otp_request_dto.dart';
import 'package:fotolou/features/authentication/data/models/user_model.dart';
import 'package:fotolou/features/authentication/data/models/verify_otp_request_dto.dart';
import 'package:fotolou/features/authentication/domain/entities/login_credentials.dart';
import 'package:fotolou/features/authentication/domain/entities/phone_otp_credentials.dart';
import 'package:fotolou/features/authentication/domain/entities/user_entity.dart';
import 'package:fotolou/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Result<UserEntity>> login(LoginCredentials credentials) {
    return guardResult<UserEntity>(() async {
      final session = await _remoteDataSource.login(
        LoginRequestDto(
          email: credentials.email,
          password: credentials.password,
        ),
      );
      await _localDataSource.cacheSession(session);

      return session.user.toEntity();
    });
  }

  @override
  Future<Result<void>> requestPhoneOtp(String phone) {
    return guardResult<void>(() async {
      await _remoteDataSource.requestPhoneOtp(PhoneOtpRequestDto(phone: phone));
    });
  }

  @override
  Future<Result<UserEntity>> verifyPhoneOtp(PhoneOtpCredentials credentials) {
    return guardResult<UserEntity>(() async {
      final session = await _remoteDataSource.verifyPhoneOtp(
        VerifyOtpRequestDto(phone: credentials.phone, otp: credentials.otp),
      );
      await _localDataSource.cacheSession(session);

      return session.user.toEntity();
    });
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() {
    return guardResult<UserEntity?>(() async {
      final cachedUser = await _localDataSource.getCachedUser();
      return cachedUser?.toEntity();
    });
  }

  @override
  Future<Result<void>> logout() {
    return guardResult<void>(() async {
      try {
        await _remoteDataSource.logout();
      } finally {
        await _localDataSource.clearSession();
      }
    });
  }
}

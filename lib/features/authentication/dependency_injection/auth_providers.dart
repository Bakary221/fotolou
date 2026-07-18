import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:fotolou/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:fotolou/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:fotolou/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fotolou/features/authentication/domain/usecases/get_current_user_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/login_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/logout_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/request_phone_otp_use_case.dart';
import 'package:fotolou/features/authentication/domain/usecases/verify_phone_otp_use_case.dart';
import 'package:fotolou/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:fotolou/features/authentication/presentation/states/auth_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.featureFlags.useMockAuthentication) {
    return const MockAuthRemoteDataSource();
  }
  return DioAuthRemoteDataSource(ref.watch(apiClientProvider));
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return SecureAuthLocalDataSource(
    localStorage: ref.watch(localStorageProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final requestPhoneOtpUseCaseProvider = Provider<RequestPhoneOtpUseCase>((ref) {
  return RequestPhoneOtpUseCase(ref.watch(authRepositoryProvider));
});

final verifyPhoneOtpUseCaseProvider = Provider<VerifyPhoneOtpUseCase>((ref) {
  return VerifyPhoneOtpUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      loginUseCase: ref.watch(loginUseCaseProvider),
      requestPhoneOtpUseCase: ref.watch(requestPhoneOtpUseCaseProvider),
      verifyPhoneOtpUseCase: ref.watch(verifyPhoneOtpUseCaseProvider),
      logoutUseCase: ref.watch(logoutUseCaseProvider),
      getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    );
  },
);

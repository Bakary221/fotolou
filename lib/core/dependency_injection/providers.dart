import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fotolou/app/config/app_config.dart';
import 'package:fotolou/core/network/api_client.dart';
import 'package:fotolou/core/network/auth_interceptor.dart';
import 'package:fotolou/core/network/connectivity_service.dart';
import 'package:fotolou/core/network/dio_factory.dart';
import 'package:fotolou/core/network/token_refresher.dart';
import 'package:fotolou/core/services/app_logger.dart';
import 'package:fotolou/core/storage/local_storage.dart';
import 'package:fotolou/core/storage/local_token_storage.dart';
import 'package:fotolou/core/storage/secure_local_storage.dart';
import 'package:fotolou/core/storage/token_storage.dart';
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

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  final config = ref.watch(appConfigProvider);
  return AppLogger(enabled: config.enableLogs);
});

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  return SecureLocalStorage(ref.watch(flutterSecureStorageProvider));
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return LocalTokenStorage(ref.watch(localStorageProvider));
});

final tokenRefresherProvider = Provider<TokenRefresher>((ref) {
  return const NoopTokenRefresher();
});

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(
    tokenStorage: ref.watch(tokenStorageProvider),
    tokenRefresher: ref.watch(tokenRefresherProvider),
  );
});

final dioProvider = Provider<Dio>((ref) {
  return const DioFactory().create(
    config: ref.watch(appConfigProvider),
    authInterceptor: ref.watch(authInterceptorProvider),
  );
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityPlusService(ref.watch(connectivityProvider));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return DioApiClient(
    dio: ref.watch(dioProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

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

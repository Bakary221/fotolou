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

final bareDioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  return Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl.toString(),
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
});

final tokenRefresherProvider = Provider<TokenRefresher>((ref) {
  return DioTokenRefresher(
    dio: ref.watch(bareDioProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(
    tokenStorage: ref.watch(tokenStorageProvider),
    tokenRefresher: ref.watch(tokenRefresherProvider),
    retryClient: ref.watch(bareDioProvider),
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

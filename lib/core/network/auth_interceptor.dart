import 'package:dio/dio.dart';
import 'package:fotolou/core/network/token_refresher.dart';
import 'package:fotolou/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required TokenRefresher tokenRefresher,
    required Dio retryClient,
  }) : _tokenStorage = tokenStorage,
       _tokenRefresher = tokenRefresher,
       _retryClient = retryClient;

  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;
  final Dio _retryClient;

  static const _retryMarker = 'fotolou.auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final hasAlreadyRetried = request.extra[_retryMarker] == true;
    if (err.response?.statusCode == 401 && !hasAlreadyRetried) {
      final refreshed = await _tokenRefresher.refreshToken();
      if (refreshed) {
        final accessToken = await _tokenStorage.readAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          request
            ..headers['Authorization'] = 'Bearer $accessToken'
            ..extra[_retryMarker] = true;

          try {
            handler.resolve(await _retryClient.fetch<Object?>(request));
            return;
          } on DioException {
            // The original 401 remains the meaningful authentication failure.
          }
        }
      }

      await _tokenStorage.clearTokens();
    }

    handler.next(err);
  }
}

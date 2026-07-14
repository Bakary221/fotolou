import 'package:dio/dio.dart';
import 'package:fotolou/core/network/token_refresher.dart';
import 'package:fotolou/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required TokenRefresher tokenRefresher,
  }) : _tokenStorage = tokenStorage,
       _tokenRefresher = tokenRefresher;

  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;

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
    if (err.response?.statusCode == 401) {
      final refreshed = await _tokenRefresher.refreshToken();
      if (!refreshed) {
        await _tokenStorage.clearTokens();
      }
    }

    handler.next(err);
  }
}

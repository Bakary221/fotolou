import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fotolou/core/storage/token_storage.dart';

abstract interface class TokenRefresher {
  Future<bool> refreshToken();
}

class DioTokenRefresher implements TokenRefresher {
  DioTokenRefresher({required Dio dio, required TokenStorage tokenStorage})
    : _dio = dio,
      _tokenStorage = tokenStorage;

  final Dio _dio;
  final TokenStorage _tokenStorage;
  Completer<bool>? _activeRefresh;

  @override
  Future<bool> refreshToken() {
    final activeRefresh = _activeRefresh;
    if (activeRefresh != null) {
      return activeRefresh.future;
    }

    final completer = Completer<bool>();
    _activeRefresh = completer;
    _performRefresh().then(
      completer.complete,
      onError: (_) => completer.complete(false),
    );
    return completer.future.whenComplete(() {
      if (identical(_activeRefresh, completer)) {
        _activeRefresh = null;
      }
    });
  }

  Future<bool> _performRefresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await _dio.post<Object?>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data;
      if (data is! Map<String, Object?>) {
        return false;
      }

      final accessToken = data['accessToken'];
      final rotatedRefreshToken = data['refreshToken'];
      if (accessToken is! String || accessToken.isEmpty) {
        return false;
      }

      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: rotatedRefreshToken is String
            ? rotatedRefreshToken
            : refreshToken,
      );
      return true;
    } on DioException {
      return false;
    }
  }
}

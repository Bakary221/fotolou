import 'dart:convert';

import 'package:fotolou/core/constants/app_constants.dart';
import 'package:fotolou/core/exceptions/app_exception.dart';
import 'package:fotolou/core/storage/local_storage.dart';
import 'package:fotolou/core/storage/token_storage.dart';
import 'package:fotolou/features/authentication/data/models/auth_session_model.dart';
import 'package:fotolou/features/authentication/data/models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheSession(AuthSessionModel session);
  Future<UserModel?> getCachedUser();
  Future<void> clearSession();
}

class SecureAuthLocalDataSource implements AuthLocalDataSource {
  const SecureAuthLocalDataSource({
    required LocalStorage localStorage,
    required TokenStorage tokenStorage,
  }) : _localStorage = localStorage,
       _tokenStorage = tokenStorage;

  final LocalStorage _localStorage;
  final TokenStorage _tokenStorage;

  @override
  Future<void> cacheSession(AuthSessionModel session) async {
    await _tokenStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    await _localStorage.saveString(
      AppConstants.cachedUserKey,
      jsonEncode(session.user.toJson()),
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final rawUser = await _localStorage.getString(AppConstants.cachedUserKey);
    if (rawUser == null) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawUser);
      if (decoded is! Map<String, Object?>) {
        throw const FormatException('Cached user is not an object.');
      }

      return UserModel.fromJson(Map<String, dynamic>.from(decoded));
    } on FormatException catch (error) {
      throw CacheException(error.message);
    } on TypeError {
      throw const CacheException('L’utilisateur en cache est invalide.');
    }
  }

  @override
  Future<void> clearSession() async {
    await _tokenStorage.clearTokens();
    await _localStorage.remove(AppConstants.cachedUserKey);
  }
}

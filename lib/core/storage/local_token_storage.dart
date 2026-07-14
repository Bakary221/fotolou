import 'package:fotolou/core/constants/app_constants.dart';
import 'package:fotolou/core/storage/local_storage.dart';
import 'package:fotolou/core/storage/token_storage.dart';

class LocalTokenStorage implements TokenStorage {
  const LocalTokenStorage(this._localStorage);

  final LocalStorage _localStorage;

  @override
  Future<String?> readAccessToken() {
    return _localStorage.getString(AppConstants.accessTokenKey);
  }

  @override
  Future<String?> readRefreshToken() {
    return _localStorage.getString(AppConstants.refreshTokenKey);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _localStorage.saveString(AppConstants.accessTokenKey, accessToken);
    await _localStorage.saveString(AppConstants.refreshTokenKey, refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _localStorage.remove(AppConstants.accessTokenKey);
    await _localStorage.remove(AppConstants.refreshTokenKey);
  }
}

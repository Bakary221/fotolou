abstract interface class TokenRefresher {
  Future<bool> refreshToken();
}

class NoopTokenRefresher implements TokenRefresher {
  const NoopTokenRefresher();

  @override
  Future<bool> refreshToken() async {
    return false;
  }
}

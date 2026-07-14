sealed class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() {
    final suffix = code == null ? '' : ' ($code)';
    return '$runtimeType: $message$suffix';
  }
}

final class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

final class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.code});
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

final class UnknownException extends AppException {
  const UnknownException(super.message, {super.code});
}

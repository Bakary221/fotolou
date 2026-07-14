import 'package:fotolou/core/exceptions/app_exception.dart';
import 'package:fotolou/core/failures/failure.dart';

Failure mapExceptionToFailure(Object exception) {
  return switch (exception) {
    ServerException(:final message, :final code) => ServerFailure(
      message,
      code: code,
    ),
    NetworkException(:final message, :final code) => NetworkFailure(
      message,
      code: code,
    ),
    CacheException(:final message, :final code) => CacheFailure(
      message,
      code: code,
    ),
    UnauthorizedException(:final message, :final code) => UnauthorizedFailure(
      message,
      code: code,
    ),
    ValidationException(:final message, :final code) => ValidationFailure(
      message,
      code: code,
    ),
    UnknownException(:final message, :final code) => UnknownFailure(
      message,
      code: code,
    ),
    _ => const UnknownFailure('Une erreur inattendue est survenue.'),
  };
}

import 'package:dio/dio.dart';
import 'package:fotolou/core/exceptions/app_exception.dart';

extension DioExceptionMapper on DioException {
  AppException toAppException() {
    final statusCode = response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      return const UnauthorizedException('Session expirée ou accès refusé.');
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        'Le serveur est momentanément indisponible.',
        code: '$statusCode',
      );
    }

    return switch (type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout ||
      DioExceptionType.connectionError => const NetworkException(
        'La connexion réseau est indisponible.',
      ),
      DioExceptionType.badResponse => ServerException(
        'La réponse du serveur est invalide.',
        code: statusCode?.toString(),
      ),
      DioExceptionType.cancel => const NetworkException(
        'La requête a été annulée.',
      ),
      DioExceptionType.badCertificate => const NetworkException(
        'Le certificat serveur est invalide.',
      ),
      DioExceptionType.unknown => UnknownException(
        message ?? 'Une erreur réseau inattendue est survenue.',
      ),
    };
  }
}

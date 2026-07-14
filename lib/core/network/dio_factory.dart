import 'package:dio/dio.dart';
import 'package:fotolou/app/config/app_config.dart';
import 'package:fotolou/core/network/auth_interceptor.dart';

class DioFactory {
  const DioFactory();

  Dio create({
    required AppConfig config,
    required AuthInterceptor authInterceptor,
  }) {
    final dio = Dio(
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

    dio.interceptors.add(authInterceptor);

    if (config.enableLogs) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    return dio;
  }
}

import 'package:dio/dio.dart';
import 'package:fotolou/core/exceptions/app_exception.dart';
import 'package:fotolou/core/network/connectivity_service.dart';
import 'package:fotolou/core/network/dio_exception_mapper.dart';

abstract interface class ApiClient {
  Future<Map<String, Object?>> getJson(
    String path, {
    Map<String, Object?>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<Map<String, Object?>> postJson(
    String path, {
    Object? data,
    CancelToken? cancelToken,
  });
}

class DioApiClient implements ApiClient {
  const DioApiClient({
    required Dio dio,
    required ConnectivityService connectivityService,
  }) : _dio = dio,
       _connectivityService = connectivityService;

  final Dio _dio;
  final ConnectivityService _connectivityService;

  @override
  Future<Map<String, Object?>> getJson(
    String path, {
    Map<String, Object?>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    await _ensureConnection();

    try {
      final response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return _decodeJsonObject(response);
    } on DioException catch (error) {
      throw error.toAppException();
    }
  }

  @override
  Future<Map<String, Object?>> postJson(
    String path, {
    Object? data,
    CancelToken? cancelToken,
  }) async {
    await _ensureConnection();

    try {
      final response = await _dio.post<Object?>(
        path,
        data: data,
        cancelToken: cancelToken,
      );

      return _decodeJsonObject(response);
    } on DioException catch (error) {
      throw error.toAppException();
    }
  }

  Future<void> _ensureConnection() async {
    if (!await _connectivityService.hasConnection) {
      throw const NetworkException('Aucune connexion réseau disponible.');
    }
  }

  Map<String, Object?> _decodeJsonObject(Response<Object?> response) {
    final data = response.data;
    if (data is Map<String, Object?>) {
      return data;
    }

    throw const ServerException('La réponse JSON doit être un objet.');
  }
}

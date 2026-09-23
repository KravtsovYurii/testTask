import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_exception.dart';

abstract class ApiClient {
  factory ApiClient({Dio? dio}) = DioApiClient;

  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}

class DioApiClient implements ApiClient {
  final Dio _dio;

  DioApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              contentType: 'application/json',
              headers: {'Accept': 'application/json'},
            ),
          );

  dynamic _parseResponse(dynamic data) {
    if (data is Map<String, dynamic> || data is List) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic> || decoded is List) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        throw const ApiException('Server Error: Invalid response format');
      }
    }
    throw const ApiException('Invalid response format from server');
  }

  @override
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseResponse(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseResponse(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException error) {
    if (error.response?.data != null) {
      try {
        final data = _parseResponse(error.response!.data);
        if (data is Map && data['message'] != null) {
          return ApiException(
            data['message'].toString(),
            error.response?.statusCode,
          );
        }
      } catch (_) {
        if (error.response?.data is String &&
            (error.response!.data as String).isNotEmpty) {
          return ApiException(
            error.response!.data as String,
            error.response?.statusCode,
          );
        }
      }
    }

    final code = error.response?.statusCode;
    if (code == 429) {
      return const ApiException('Too many requests', 429);
    }
    if (code != null) {
      final statusMessage = error.response?.statusMessage ?? '';
      return ApiException('Server error ($code) $statusMessage'.trim(), code);
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('Connection timeout');
      case DioExceptionType.connectionError:
        return const ApiException('Connection error');
      default:
        final detail = error.error?.toString() ?? error.message;
        return ApiException(
          detail != null && detail.isNotEmpty ? detail : 'Network error',
        );
    }
  }
}

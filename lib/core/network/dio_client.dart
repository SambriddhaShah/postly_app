import 'package:dio/dio.dart';
import '../errors/failures.dart';
import 'api_urls.dart';

class DioClient {
  final Dio _dio;
  DioClient(this._dio) {
    _dio.options.baseUrl = ApiUrls.baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add headers (auth) here if needed
          handler.next(options);
        },
        onError: (error, handler) {
          // Map DioError -> Failure and attach to DioError.error
          final mapped = _mapDioError(error);
          final newError = DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: mapped,
            stackTrace: error.stackTrace,
          );
          handler.reject(newError);
        },
        onResponse: (response, handler) {
          print(
              'Response StatusCode -> ${response.statusCode} ,Response [${response.data}] => PATH: ${response.requestOptions.path}');
          handler.next(response);
        },
      ),
    );
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkFailure('Connection timed out');
    } else if (e.type == DioExceptionType.badResponse) {
      final status = e.response?.statusCode;
      return ServerFailure('Server error${status != null ? ': $status' : ''}');
    } else if (e.type == DioExceptionType.unknown && e.error != null) {
      // Could be socket exception
      return NetworkFailure(e.message ?? 'Network error');
    }
    return ServerFailure(e.message ?? 'Unexpected error');
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      // If interceptor already attached a Failure, rethrow it to caller
      if (e.error is Failure) throw e.error as Failure;
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      if (e.error is Failure) throw e.error as Failure;
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      if (e.error is Failure) throw e.error as Failure;
      rethrow;
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } on DioException catch (e) {
      if (e.error is Failure) throw e.error as Failure;
      rethrow;
    }
  }
}

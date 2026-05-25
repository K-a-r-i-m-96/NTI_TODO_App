import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:untitled/core/cache/cache_helper.dart';
import 'package:untitled/core/network/end_points.dart';

abstract class ApiHelper {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: EndPoints.baseUrl,
    receiveDataWhenStatusError: true,
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
        return handler.next(error);
      },
    ));

  static Future<Either<String, Map<String, dynamic>>> post({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    bool isFormData = true,
    bool isProtected = false,
  }) async {
    try {
      var response = await dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: {
          if (isProtected) 'Authorization': 'Bearer ${CacheHelper.getValue('token')}',
          ...?headers,
        }),
      );
      return right(response.data as Map<String, dynamic>);
    } catch (e) {
      String errorMsg = 'Something went wrong';
      if (e is DioException) {
        if (e.response?.data is Map<String, dynamic>) {
          errorMsg = e.response?.data['message'] ?? e.message;
        } else {
          errorMsg = e.message ?? 'Unknown error';
        }
      }
      return left(errorMsg);
    }
  }

  static Future<Either<String, Map<String, dynamic>>> get({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      var response = await dio.get(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        queryParameters: queryParameters,
        options: Options(headers: {
          if (isProtected) 'Authorization': 'Bearer ${CacheHelper.getValue('token')}',
          ...?headers,
        }),
      );
      return right(response.data as Map<String, dynamic>);
    } catch (e) {
      String errorMsg = 'Something went wrong';
      if (e is DioException) {
        if (e.response?.data is Map<String, dynamic>) {
          errorMsg = e.response?.data['message'] ?? e.message;
        } else {
          errorMsg = e.message ?? 'Unknown error';
        }
      }
      return left(errorMsg);
    }
  }

  static Future<Either<String, Map<String, dynamic>>> put({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    bool isFormData = true,
    bool isProtected = false,
  }) async {
    try {
      var response = await dio.put(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: {
          if (isProtected) 'Authorization': 'Bearer ${CacheHelper.getValue('token')}',
          ...?headers,
        }),
      );
      return right(response.data as Map<String, dynamic>);
    } catch (e) {
      String errorMsg = 'Something went wrong';
      if (e is DioException) {
        if (e.response?.data is Map<String, dynamic>) {
          errorMsg = e.response?.data['message'] ?? e.message;
        } else {
          errorMsg = e.message ?? 'Unknown error';
        }
      }
      return left(errorMsg);
    }
  }

  static Future<Either<String, Map<String, dynamic>>> delete({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    bool isFormData = true,
    bool isProtected = false,
  }) async {
    try {
      var response = await dio.delete(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: {
          if (isProtected) 'Authorization': 'Bearer ${CacheHelper.getValue('token')}',
          ...?headers,
        }),
      );
      return right(response.data as Map<String, dynamic>);
    } catch (e) {
      String errorMsg = 'Something went wrong';
      if (e is DioException) {
        if (e.response?.data is Map<String, dynamic>) {
          errorMsg = e.response?.data['message'] ?? e.message;
        } else {
          errorMsg = e.message ?? 'Unknown error';
        }
      }
      return left(errorMsg);
    }
  }
}

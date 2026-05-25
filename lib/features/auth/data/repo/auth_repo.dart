import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:untitled/core/network/api_helper.dart';
import 'package:untitled/core/network/end_points.dart';

class AuthRepo {
  Future<Either<String, Map<String, dynamic>>> login({
    required String username,
    required String password,
  }) async {
    return await ApiHelper.post(
      endPoint: EndPoints.login,
      data: {
        'username': username,
        'password': password,
      },
    );
  }

  Future<Either<String, Map<String, dynamic>>> register({
    required String username,
    required String password,
    String? imagePath,
  }) async {
    return await ApiHelper.post(
      endPoint: EndPoints.register,
      data: {
        'username': username,
        'password': password,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      },
      isFormData: true,
    );
  }
}

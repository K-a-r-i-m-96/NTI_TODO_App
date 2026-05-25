import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:untitled/core/network/api_helper.dart';
import 'package:untitled/core/network/end_points.dart';
import 'package:untitled/features/home/data/models/task_model.dart';

class HomeRepo {
  Future<Either<String, List<TaskModel>>> getTasks() async {
    var result = await ApiHelper.get(
      endPoint: EndPoints.myTasks,
      isProtected: true,
    );
    return result.fold(
      (error) => left(error),
      (map) {
        if (map['tasks'] != null) {
          var tasks = (map['tasks'] as List).map((e) => TaskModel.fromJson(e)).toList();
          return right(tasks);
        }
        return right([]);
      },
    );
  }

  Future<Either<String, String>> createTask({
    required String title,
    required String description,
    required String group,
    required String date,
    bool isDone = false,
    String? imagePath,
  }) async {
    final serializedTitle = "${title.replaceAll('|', ' ')}|date:$date|group:$group|isDone:$isDone";
    final gmtDate = TaskModel.formatToGmt(date);
    var result = await ApiHelper.post(
      endPoint: EndPoints.newTask,
      data: {
        'title': serializedTitle,
        'description': description,
        'group': group,
        'date': date,
        if (gmtDate != null) 'created_at': gmtDate,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      },
      isProtected: true,
      isFormData: true,
    );
    return result.fold(
      (error) => left(error),
      (map) => right(map['message'] ?? 'Success'),
    );
  }

  Future<Either<String, String>> updateTask({
    required int id,
    required String title,
    required String description,
    required String group,
    required String date,
    bool isDone = false,
    String? imagePath,
  }) async {
    final serializedTitle = "${title.replaceAll('|', ' ')}|date:$date|group:$group|isDone:$isDone";
    final gmtDate = TaskModel.formatToGmt(date);
    var result = await ApiHelper.put(
      endPoint: EndPoints.updateTask(taskId: id),
      data: {
        'title': serializedTitle,
        'description': description,
        'group': group,
        'date': date,
        if (gmtDate != null) 'created_at': gmtDate,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      },
      isProtected: true,
      isFormData: true,
    );
    return result.fold(
      (error) => left(error),
      (map) => right(map['message'] ?? 'Success'),
    );
  }

  Future<Either<String, String>> deleteTask(int id) async {
    var result = await ApiHelper.delete(
      endPoint: EndPoints.updateTask(taskId: id),
      isProtected: true,
    );
    return result.fold(
      (error) => left(error),
      (map) => right(map['message'] ?? 'Success'),
    );
  }

}

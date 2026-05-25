import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/home/cubit/update_task/update_task_state.dart';
import 'package:untitled/features/home/data/models/task_model.dart';
import 'package:untitled/features/home/data/repo/home_repo.dart';

import 'package:untitled/core/cache/cache_helper.dart';

class UpdateTaskCubit extends Cubit<UpdateTaskState> {
  final TaskModel taskModel;
  
  UpdateTaskCubit(this.taskModel) : super(UpdateTaskInitialState()) {
    title.text = taskModel.title ?? '';
    description.text = taskModel.description ?? '';
    dateController.text = taskModel.date ?? '';
    selectedDate = _parseDateTime(taskModel.date);
    
    const validGroups = ['Home', 'Personal', 'Work'];
    if (validGroups.contains(taskModel.group)) {
      selectedGroup = taskModel.group;
    } else {
      selectedGroup = 'Home';
    }

    isDone = taskModel.isDone == 'true';
  }

  DateTime? _parseDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final parts = dateStr.trim().split(RegExp(r'\s+'));
      if (parts.length >= 3) {
        if (parts[0].contains('/')) {
          final dateParts = parts[0].split('/');
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);

          final timeParts = parts[1].split(':');
          var hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final period = parts[2].toUpperCase();

          if (period == 'PM' && hour < 12) hour += 12;
          if (period == 'AM' && hour == 12) hour = 0;

          return DateTime(year, month, day, hour, minute);
        } else {
          final day = int.parse(parts[0]);
          final monthStr = parts[1].replaceAll(',', '');
          final year = int.parse(parts[2]);

          final months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December',
            'Jan', 'Feb', 'Mar', 'Apr', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          
          int month = 1;
          for (int i = 0; i < months.length; i++) {
            if (months[i].toLowerCase() == monthStr.toLowerCase()) {
              month = (i % 12) + 1;
              break;
            }
          }

          final timeParts = parts[3].split(':');
          var hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final period = parts[4].toUpperCase();

          if (period == 'PM' && hour < 12) hour += 12;
          if (period == 'AM' && hour == 12) hour = 0;

          return DateTime(year, month, day, hour, minute);
        }
      }
    } catch (_) {}
    return null;
  }

  static UpdateTaskCubit get(context) => BlocProvider.of(context);

  final HomeRepo repo = HomeRepo();
  final title = TextEditingController();
  final description = TextEditingController();
  final dateController = TextEditingController();
  String? selectedGroup;
  DateTime? selectedDate;
  bool isDone = false;

  void onGroupChanged(String? value) {
    selectedGroup = value;
    emit(UpdateTaskInitialState()); 
  }

  void onDateChanged(DateTime date, TimeOfDay time) {
    selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    String period = time.hour >= 12 ? 'PM' : 'AM';
    int hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    String hourStr = hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    
    dateController.text = "${date.day} ${months[date.month - 1]}, ${date.year}    $hourStr:$minute $period";
    emit(UpdateTaskInitialState());
  }

  void markAsDone() {
    isDone = true;
    updateTask();
  }

  Future<void> updateTask() async {
    if (title.text.isNotEmpty && taskModel.id != null) {
      emit(UpdateTaskLoadingState());
      
      if (taskModel.id != null) {
        await CacheHelper.setValue(key: 'task_date_${taskModel.id}', value: dateController.text);
      }
      final cleanTitle = title.text.trim().replaceAll(RegExp(r'\s+'), '_');
      final cleanDesc = description.text.trim().replaceAll(RegExp(r'\s+'), '_');
      await CacheHelper.setValue(key: 'task_date_${cleanTitle}_$cleanDesc', value: dateController.text);

      var result = await repo.updateTask(
        id: taskModel.id!,
        title: title.text,
        description: description.text,
        group: selectedGroup ?? 'Home',
        date: dateController.text,
        isDone: isDone,
      );
      result.fold(
        (error) => emit(UpdateTaskErrorState(error)),
        (message) {
          taskModel.title = title.text;
          taskModel.description = description.text;
          taskModel.group = selectedGroup;
          taskModel.date = dateController.text;
          taskModel.isDone = isDone.toString();
          emit(UpdateTaskSuccessState(message));
        },
      );
    } else {
      emit(UpdateTaskErrorState('Title cannot be empty'));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/home/cubit/add_task/add_task_state.dart';
import 'package:untitled/features/home/data/repo/home_repo.dart';

import 'package:untitled/core/cache/cache_helper.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);

  final HomeRepo repo = HomeRepo();
  
  final title = TextEditingController();
  final description = TextEditingController();
  final dateController = TextEditingController();
  
  String? selectedGroup = 'Home';
  DateTime? selectedDate;

  void onGroupChanged(String? value) {
    selectedGroup = value;
    emit(AddTaskGroupChangedState());
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
    emit(AddTaskDatePickedState());
  }

  Future<void> addTask() async {
    if (title.text.isNotEmpty) {
      emit(AddTaskLoadingState());
      
      final cleanTitle = title.text.trim().replaceAll(RegExp(r'\s+'), '_');
      final cleanDesc = description.text.trim().replaceAll(RegExp(r'\s+'), '_');
      await CacheHelper.setValue(
        key: 'task_date_${cleanTitle}_$cleanDesc',
        value: dateController.text,
      );

      var result = await repo.createTask(
        title: title.text,
        description: description.text,
        group: selectedGroup ?? 'Home',
        date: dateController.text,
        isDone: false,
      );
      result.fold(
        (error) => emit(AddTaskErrorState(error)),
        (message) => emit(AddTaskSuccessState(message)),
      );
    } else {
      emit(AddTaskErrorState('Please enter a title'));
    }
  }
}

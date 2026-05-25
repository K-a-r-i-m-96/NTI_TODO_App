import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/home/cubit/get_tasks/get_tasks_state.dart';
import 'package:untitled/features/home/data/models/task_model.dart';
import 'package:untitled/features/home/data/repo/home_repo.dart';

class GetTasksCubit extends Cubit<GetTasksState> {
  GetTasksCubit() : super(GetTasksInitialState());

  static GetTasksCubit get(context) => BlocProvider.of(context);

  final HomeRepo repo = HomeRepo();
  List<TaskModel> tasks = [];

  Future<void> getTasks() async {
    emit(GetTasksLoadingState());
    var result = await repo.getTasks();
    result.fold(
      (error) => emit(GetTasksErrorState(error)),
      (fetchedTasks) {
        tasks = fetchedTasks;
        emit(GetTasksSuccessState(tasks));
      },
    );
  }

  void updateLocalTasks(List<TaskModel> newList) {
    tasks = newList;
    emit(GetTasksSuccessState(tasks));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/home/cubit/delete_task/delete_task_state.dart';
import 'package:untitled/features/home/data/models/task_model.dart';
import 'package:untitled/features/home/data/repo/home_repo.dart';

class DeleteTaskCubit extends Cubit<DeleteTaskState> {
  final TaskModel taskModel;
  
  DeleteTaskCubit(this.taskModel) : super(DeleteTaskInitialState());

  static DeleteTaskCubit get(context) => BlocProvider.of(context);

  final HomeRepo repo = HomeRepo();

  Future<void> deleteTask() async {
    if (taskModel.id != null) {
      emit(DeleteTaskLoadingState());
      var result = await repo.deleteTask(taskModel.id!);
      result.fold(
        (error) => emit(DeleteTaskErrorState(error)),
        (message) => emit(DeleteTaskSuccessState(message)),
      );
    } else {
      emit(DeleteTaskErrorState('Task ID not found'));
    }
  }
}

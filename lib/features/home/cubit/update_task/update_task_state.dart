abstract class UpdateTaskState {}

class UpdateTaskInitialState extends UpdateTaskState {}

class UpdateTaskLoadingState extends UpdateTaskState {}

class UpdateTaskSuccessState extends UpdateTaskState {
  final String message;
  UpdateTaskSuccessState(this.message);
}

class UpdateTaskErrorState extends UpdateTaskState {
  final String error;
  UpdateTaskErrorState(this.error);
}

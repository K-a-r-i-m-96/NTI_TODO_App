abstract class DeleteTaskState {}

class DeleteTaskInitialState extends DeleteTaskState {}

class DeleteTaskLoadingState extends DeleteTaskState {}

class DeleteTaskSuccessState extends DeleteTaskState {
  final String message;
  DeleteTaskSuccessState(this.message);
}

class DeleteTaskErrorState extends DeleteTaskState {
  final String error;
  DeleteTaskErrorState(this.error);
}

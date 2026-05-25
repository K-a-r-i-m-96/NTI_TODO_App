abstract class AddTaskState {}

class AddTaskInitialState extends AddTaskState {}

class AddTaskLoadingState extends AddTaskState {}

class AddTaskSuccessState extends AddTaskState {
  final String message;
  AddTaskSuccessState(this.message);
}

class AddTaskErrorState extends AddTaskState {
  final String error;
  AddTaskErrorState(this.error);
}

class AddTaskDatePickedState extends AddTaskState {}

class AddTaskGroupChangedState extends AddTaskState {}

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final Map<String, dynamic> user;
  RegisterSuccessState(this.user);
}

class RegisterErrorState extends RegisterState {
  final String error;
  RegisterErrorState(this.error);
}

class RegisterPasswordVisibilityState extends RegisterState {}

class RegisterConfirmPasswordVisibilityState extends RegisterState {}

class RegisterImagePickedState extends RegisterState {}

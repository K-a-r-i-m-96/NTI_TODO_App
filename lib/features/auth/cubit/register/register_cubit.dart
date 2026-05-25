import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/features/auth/cubit/register/register_state.dart';
import 'package:untitled/features/auth/data/repo/auth_repo.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  final AuthRepo repo = AuthRepo();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  File? image;
  final ImagePicker _picker = ImagePicker();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(RegisterPasswordVisibilityState());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(RegisterConfirmPasswordVisibilityState());
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(RegisterImagePickedState());
    }
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      emit(RegisterLoadingState());
      var result = await repo.register(
        username: username.text,
        password: password.text,
        imagePath: image?.path,
      );
      result.fold(
        (error) => emit(RegisterErrorState(error)),
        (user) => emit(RegisterSuccessState(user)),
      );
    }
  }
}

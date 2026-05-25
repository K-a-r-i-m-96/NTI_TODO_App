import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/cache/cache_helper.dart';
import 'package:untitled/features/auth/cubit/login/login_state.dart';
import 'package:untitled/features/auth/data/repo/auth_repo.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  final AuthRepo repo = AuthRepo();
  final username = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginPasswordVisibilityState());
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoadingState());
      var result = await repo.login(
        username: username.text,
        password: password.text,
      );
      result.fold(
        (error) => emit(LoginErrorState(error)),
        (data) async {
          String? token = data['access_token'] ?? data['token'];
          if (token != null) {
            await CacheHelper.setValue(key: 'token', value: token);
            emit(LoginSuccessState(data));
          } else {
            emit(LoginErrorState('Login successful but token not found'));
          }
        },
      );
    }
  }
}

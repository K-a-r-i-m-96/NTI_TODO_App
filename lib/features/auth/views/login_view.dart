import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/components/default_btn.dart';
import 'package:untitled/core/components/default_text_field.dart';
import 'package:untitled/features/auth/cubit/login/login_cubit.dart';
import 'package:untitled/features/auth/cubit/login/login_state.dart';
import 'package:untitled/features/auth/views/register_view.dart';
import 'package:untitled/features/home/views/home_view.dart';

import 'package:untitled/l10n/app_localizations.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is LoginSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false,
            );
          } else if (state is LoginErrorState) {
            var errorMsg = state.error;
            if (errorMsg == 'Please enter karem@gmail.com') {
              errorMsg = l10n.pleaseEnterEmail;
            } else if (errorMsg == 'Please enter a valid email address') {
              errorMsg = l10n.pleaseEnterValidEmail;
            } else if (errorMsg == 'Please enter password') {
              errorMsg = l10n.pleaseEnterPassword;
            } else if (errorMsg == 'Min 8 chars, at least one letter and one number') {
              errorMsg = l10n.passwordValidation;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            backgroundColor: const Color(0xFFFBFBFB),
            body: SingleChildScrollView(
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.42,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/images/GettyImages-1315607788 2.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          DefaultTextField(
                            controller: cubit.username,
                            hintText: l10n.email,
                            svgPrefixIcon: 'assets/images/Profile - Iconly Pro.svg',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.pleaseEnterEmail;
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return l10n.pleaseEnterValidEmail;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          DefaultTextField(
                            controller: cubit.password,
                            hintText: l10n.password,
                            svgPrefixIcon: 'assets/images/Password - Iconly Pro.svg',
                            svgPasswordVisibleIcon: 'assets/images/Unlock - Iconly Pro.svg',
                            svgPasswordHiddenIcon: 'assets/images/Unlock - Iconly Pro.svg',
                            isPassword: true,
                            isPasswordVisible: cubit.isPasswordVisible,
                            onPasswordToggle: cubit.togglePasswordVisibility,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.pleaseEnterPassword;
                              }
                              if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value)) {
                                return l10n.passwordValidation;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          if (state is LoginLoadingState)
                            const CircularProgressIndicator(color: Color(0xFF1B9E5A))
                          else
                            DefaultBtn(
                              text: l10n.login,
                              onTap: cubit.login,
                            ),
                          const SizedBox(height: 45),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.dontHaveAccount,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterView()),
                                ),
                                child: Text(
                                  l10n.register,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

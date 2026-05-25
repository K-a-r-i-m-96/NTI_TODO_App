import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/components/default_btn.dart';
import 'package:untitled/core/components/default_text_field.dart';
import 'package:untitled/features/auth/cubit/register/register_cubit.dart';
import 'package:untitled/features/auth/cubit/register/register_state.dart';
import 'package:untitled/features/auth/views/login_view.dart';

import 'package:untitled/l10n/app_localizations.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is RegisterSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          } else if (state is RegisterErrorState) {
            var errorMsg = state.error;
            if (errorMsg == 'Please enter email') {
              errorMsg = l10n.pleaseEnterEmail;
            } else if (errorMsg == 'Please enter a valid email address') {
              errorMsg = l10n.pleaseEnterValidEmail;
            } else if (errorMsg == 'Please enter password') {
              errorMsg = l10n.pleaseEnterPassword;
            } else if (errorMsg == 'Min 8 chars, at least one letter and one number') {
              errorMsg = l10n.passwordValidation;
            } else if (errorMsg == 'Please confirm your password') {
              errorMsg = l10n.pleaseConfirmPassword;
            } else if (errorMsg == 'Passwords do not match') {
              errorMsg = l10n.passwordsDoNotMatch;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            backgroundColor: const Color(0xFFFBFBFB),
            body: SingleChildScrollView(
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.42,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            image: cubit.image != null
                                ? DecorationImage(
                                    image: FileImage(cubit.image!),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage('assets/images/GettyImages-1315607788 2.png'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: cubit.pickImage,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  l10n.pickImage,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                          const SizedBox(height: 18),
                          DefaultTextField(
                            controller: cubit.confirmPassword,
                            hintText: l10n.confirmPassword,
                            svgPrefixIcon: 'assets/images/Password - Iconly Pro.svg',
                            svgPasswordVisibleIcon: 'assets/images/Unlock - Iconly Pro.svg',
                            svgPasswordHiddenIcon: 'assets/images/Unlock - Iconly Pro.svg',
                            isPassword: true,
                            isPasswordVisible: cubit.isConfirmPasswordVisible,
                            onPasswordToggle: cubit.toggleConfirmPasswordVisibility,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.pleaseConfirmPassword;
                              }
                              if (value != cubit.password.text) {
                                return l10n.passwordsDoNotMatch;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          if (state is RegisterLoadingState)
                            const CircularProgressIndicator(color: Color(0xFF1B9E5A))
                          else
                            DefaultBtn(
                              text: l10n.register,
                              onTap: cubit.register,
                            ),
                          const SizedBox(height: 45),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.alreadyHaveAccount,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginView()),
                                ),
                                child: Text(
                                  l10n.login,
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

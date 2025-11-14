import 'dart:developer';

import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/core/common/widgets/snackbar.dart';
import 'package:blog_app/core/font/app_font.dart';
import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.12),

              Text('Sign In.', style: AppFonts.bold58()),
              SizedBox(height: size.height * 0.02),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    log(state.message);
                    return showSnackBar(context, state.message);
                  }
                  if (state is AuthSuccess) {
                    return showSnackBar(context, state.user.id.toString());
                  }
                },
                builder: (context, state) {
                  // if (state is AuthLoading) {
                  //   return Loader();
                  // }
                  return Form(
                    key: key,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.02),
                        AuthField(
                          hintText: 'Email',
                          controller: emailController,
                        ),
                        SizedBox(height: size.height * 0.02),
                        AuthField(
                          hintText: 'Password',
                          controller: passwordController,
                        ),
                        SizedBox(height: size.height * 0.06),
                        AuthGradientButton(
                          loading: state is AuthLoading ? true : false,
                          buttonText: 'Sign In',
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthSignIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  context.push(RouteEndpoints.signUp);
                },

                child: RichText(
                  text: TextSpan(
                    style: AppFonts.medium22(),
                    children: [
                      TextSpan(text: 'Don\'t have an account? '),
                      TextSpan(
                        text: 'Sign Up',
                        style: AppFonts.medium22(color: AppColors.gradient2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

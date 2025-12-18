import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:blog_app/core/utils/snackbar.dart';
import 'package:blog_app/core/font/app_font.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
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

              Text('Sign Up.', style: AppFonts.bold58()),
              SizedBox(height: size.height * 0.02),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    showSnackBar(context, state.message);
                  }
                  if (state is AuthSuccess) {
                    context.goNamed(RouteEndpoints.homeName);
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: key,
                    child: Column(
                      children: [
                        AuthField(hintText: 'Name', controller: nameController),
                        SizedBox(height: size.height * 0.02),
                        AuthField(
                          hintText: 'Email',
                          type: 'email',
                          controller: emailController,
                        ),
                        SizedBox(height: size.height * 0.02),
                        AuthField(
                          hintText: 'Password',
                          type: 'password',
                          controller: passwordController,
                        ),
                        SizedBox(height: size.height * 0.06),
                        AuthGradientButton(
                          loading: state is AuthLoading ? true : false,
                          buttonText: 'Sign Up',
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthSignUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  name: nameController.text.trim(),
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
                  context.pop();
                },
                child: RichText(
                  text: TextSpan(
                    style: AppFonts.medium22(),
                    children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Login',
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

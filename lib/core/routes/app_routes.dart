// core/routes/app_router.dart
import 'package:blog_app/core/common/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouteEndpoints.login,
      name: 'login',
      builder: (context, state) =>
          BlocSelector<AppUserCubit, AppUserState, bool>(
            selector: (state) {
              return state is AppUserLoggedIn ? true : false;
            },
            builder: (context, isLoggedIn) {
              if (isLoggedIn) {
                return const LoginPage();
              } else {
                return AddNewBlogPage();
              }
            },
          ),
    ),
    GoRoute(
      path: RouteEndpoints.signUp,
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    // GoRoute(
    //   path: '/home',
    //   name: 'home',
    //   builder: (context, state) => const HomePage(),
    // ),
  ],
);


/*
Action	Method	Description
1. Navigate to a new screen (replace current route)	context.go('/signup')	Replaces current route (like Navigator.pushReplacement)
2. Push a new screen (keeps current route)	context.push('/signup')	Pushes new route (like Navigator.push)
3. Go back	context.pop()	Pops the top screen (like Navigator.pop)
4. Navigate by route name	context.goNamed('signup')	Cleaner and avoids hardcoded paths
 */
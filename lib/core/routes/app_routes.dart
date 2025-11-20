import 'package:blog_app/core/common/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:blog_app/core/common/pages/splash_page.dart';
import 'package:blog_app/core/routes/auth_refresh_notifier.dart';
import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:go_router/go_router.dart';

final _authRefreshNotifier = AuthRefreshNotifier(
  serviceLocator<AppUserCubit>(),
);

final GoRouter appRouter = GoRouter(
  initialLocation: RouteEndpoints.splash,
  refreshListenable: _authRefreshNotifier,
  redirect: (context, state) {
    final isChecking = _authRefreshNotifier.isChecking;
    final isLoggedIn = _authRefreshNotifier.isLoggedIn;
    final currentLocation = state.matchedLocation;

    if (isChecking && currentLocation != RouteEndpoints.splash) {
      return RouteEndpoints.splash;
    }
    if (!isChecking) {
      if (isLoggedIn) {
        return RouteEndpoints.home;
      } else {
        return RouteEndpoints.login;
      }
    }
    return null;
  },

  routes: [
    GoRoute(
      path: RouteEndpoints.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteEndpoints.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteEndpoints.signUp,
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: RouteEndpoints.home,
      name: 'addNewBlog',
      builder: (context, state) => const AddNewBlogPage(),
    ),
  ],
);


/*
Action	Method	Description
1. Navigate to a new screen (replace current route)	context.go('/signup')	Replaces current route (like Navigator.pushReplacement)
2. Push a new screen (keeps current route)	context.push('/signup')	Pushes new route (like Navigator.push)
3. Go back	context.pop()	Pops the top screen (like Navigator.pop)
4. Navigate by route name	context.goNamed('signup')	Cleaner and avoids hardcoded paths
 */
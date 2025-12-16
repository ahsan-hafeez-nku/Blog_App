import 'package:blog_app/core/common/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:blog_app/core/common/pages/splash_page.dart';
import 'package:blog_app/core/routes/auth_refresh_notifier.dart';
import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
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

    // If checking auth state, show splash
    if (isChecking) {
      return RouteEndpoints.splash;
    }

    // After checking is done
    if (!isChecking) {
      // If on splash, redirect based on auth state
      if (currentLocation == RouteEndpoints.splash) {
        return isLoggedIn ? RouteEndpoints.home : RouteEndpoints.login;
      }

      // Protect authenticated routes
      if (isLoggedIn) {
        // User is logged in, check if they're trying to access auth pages
        if (currentLocation == RouteEndpoints.login ||
            currentLocation == RouteEndpoints.signUp) {
          return RouteEndpoints.home;
        }
        // Allow navigation to any other route
        return null;
      } else {
        // User is not logged in, redirect to login unless already on auth pages
        if (currentLocation != RouteEndpoints.login &&
            currentLocation != RouteEndpoints.signUp) {
          return RouteEndpoints.login;
        }
        return null;
      }
    }

    return null;
  },

  routes: [
    GoRoute(
      path: RouteEndpoints.splash,
      name: RouteEndpoints.splashName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteEndpoints.login,
      name: RouteEndpoints.loginName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteEndpoints.signUp,
      name: RouteEndpoints.signUpName,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: RouteEndpoints.home,
      name: RouteEndpoints.homeName,
      builder: (context, state) => const BlogPage(),
    ),
    GoRoute(
      path: RouteEndpoints.addBlogScreen,
      name: RouteEndpoints.addBlogScreenName,
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

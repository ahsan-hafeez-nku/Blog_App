part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

/// Initial state when app starts - checking authentication
final class AppUserChecking extends AppUserState {}

/// State when user is not logged in
final class AppUserInitial extends AppUserState {}

/// State when user is logged in
final class AppUserLoggedIn extends AppUserState {
  final UserEntity user;
  AppUserLoggedIn(this.user);
}

// Core can not depend on other Features but
// Other Features can depend on Core

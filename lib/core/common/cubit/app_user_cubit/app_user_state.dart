part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final UserEntity user;
  AppUserLoggedIn(this.user);
}

// Core can not depend on other Features but
// Other Features can depend on Core

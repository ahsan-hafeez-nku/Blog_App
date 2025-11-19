part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUp({required this.name, required this.email, required this.password});
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({required this.email, required this.password});
}

class AuthIsUserLoggedIn extends AuthEvent {
  AuthIsUserLoggedIn();
}

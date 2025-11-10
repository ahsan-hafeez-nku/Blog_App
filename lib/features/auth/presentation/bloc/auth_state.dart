part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  String message;
  AuthFailure(this.message);
}

final class AuthLoading extends AuthState {}

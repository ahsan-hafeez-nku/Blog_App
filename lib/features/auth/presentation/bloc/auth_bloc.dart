import 'package:blog_app/core/error/auth_api_exception.dart';
import 'package:blog_app/features/auth/domain/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/usercase/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usercase/user_sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  AuthBloc({required UserSignUp userSignUp, required UserSignIn userSignIn})
    : _userSignUp = userSignUp,
      _userSignIn = userSignIn,
      super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      try {
        emit(AuthLoading());
        final res = await _userSignUp.call(
          UserSignUpParams(
            name: event.name,
            email: event.email,
            password: event.password,
          ),
        );
        res.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (success) => emit(AuthSuccess(success)),
        );
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthSignIn>((event, emit) async {
      try {
        emit(AuthLoading());

        final res = await _userSignIn.call(
          UserSignInParams(email: event.email, password: event.password),
        );

        res.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (success) => emit(AuthSuccess(success)),
        );
      } on AuthApiException catch (e) {
        emit(AuthFailure(e.statusCode.toString()));
      } catch (e) {
        emit(AuthFailure("Something went wrong"));
      }
    });
  }
}

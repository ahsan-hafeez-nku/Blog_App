import 'dart:developer';

import 'package:blog_app/core/common/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:blog_app/core/error/auth_api_exception.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/usercase/current_user.dart';
import 'package:blog_app/features/auth/domain/usercase/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usercase/user_sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _userSignUp = userSignUp,
       _userSignIn = userSignIn,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onSignUpEvent);
    on<AuthSignIn>(_onSignInEvent);
    on<AuthIsUserLoggedIn>(_onUserLoggedInEvent);
  }
  void _onSignUpEvent(AuthSignUp event, Emitter<AuthState> emit) async {
    try {
      // emit(AuthLoading());
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
  }

  void _onSignInEvent(AuthSignIn event, Emitter<AuthState> emit) async {
    try {
      // emit(AuthLoading());
      final res = await _userSignIn.call(
        UserSignInParams(email: event.email, password: event.password),
      );

      res.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => _emitAuthSuccess(user, emit),
      );
    } on AuthApiException catch (e) {
      emit(AuthFailure(e.statusCode.toString()));
    } catch (e) {
      emit(AuthFailure("Something went wrong"));
    }
  }

  void _onUserLoggedInEvent(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Set checking state (shows splash screen)
      _appUserCubit.setChecking();
      
      final res = await _currentUser.call(NoParams());
      res.fold(
        (l) {
          // User not logged in - clear checking state
          _appUserCubit.updateUser(null);
          emit(AuthFailure(l.message));
        },
        (user) {
          log("User Email: ${user.email}");
          _emitAuthSuccess(user, emit);
        },
      );
    } on AuthApiException catch (e) {
      // User not logged in - clear checking state
      _appUserCubit.updateUser(null);
      emit(AuthFailure(e.statusCode.toString()));
    } catch (e) {
      // User not logged in - clear checking state
      _appUserCubit.updateUser(null);
      emit(AuthFailure("Something went wrong"));
    }
  }

  void _emitAuthSuccess(UserEntity user, Emitter<AuthState> emit) async {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}

// Presentation Layer (Bloc, Pages, Widget) => Bloc help to communicate the pages to Domain layer using the User Case in the domain Layer

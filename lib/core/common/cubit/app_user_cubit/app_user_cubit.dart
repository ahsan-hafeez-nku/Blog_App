import 'package:blog_app/core/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserChecking());

  /// Set checking state (for splash screen)
  void setChecking() {
    emit(AppUserChecking());
  }

  /// Update user state after authentication check
  void updateUser(UserEntity? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(user));
    }
  }
}

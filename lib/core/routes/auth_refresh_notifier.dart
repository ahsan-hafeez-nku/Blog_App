import 'dart:async';

import 'package:blog_app/core/common/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:flutter/material.dart';

class AuthRefreshNotifier extends ChangeNotifier {
  final AppUserCubit _appUserCubit;
  late final StreamSubscription _subscription;

  AuthRefreshNotifier(this._appUserCubit) {
    _subscription = _appUserCubit.stream.listen((_) {
      notifyListeners();
    });
  }
  bool get isChecking => _appUserCubit.state is AppUserChecking;
  bool get isLoggedIn => _appUserCubit.state is AppUserLoggedIn;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

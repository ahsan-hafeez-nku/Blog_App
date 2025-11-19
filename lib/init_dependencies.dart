import 'package:blog_app/core/common/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secret.dart';
import 'package:blog_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/usercase/current_user.dart';
import 'package:blog_app/features/auth/domain/usercase/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usercase/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecret.supabaseUrl,
    anonKey: AppSecret.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator
    // Data Sourece
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    // Use
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserSignIn(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        currentUser: serviceLocator<CurrentUser>(),
        userSignUp: serviceLocator<UserSignUp>(),
        userSignIn: serviceLocator<UserSignIn>(),
        appUserCubit: serviceLocator<AppUserCubit>(),
      ),
    );
}

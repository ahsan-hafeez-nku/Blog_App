import 'package:blog_app/core/common/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:blog_app/core/network/internet_checker.dart';
import 'package:blog_app/core/secrets/app_secret.dart';
import 'package:blog_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/usercase/current_user.dart';
import 'package:blog_app/features/auth/domain/usercase/logout_user.dart';
import 'package:blog_app/features/auth/domain/usercase/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usercase/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/data_source/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/features/blog/domain/use_case/delete_blog.dart';
import 'package:blog_app/features/blog/domain/use_case/get_all_blog.dart';
import 'package:blog_app/features/blog/domain/use_case/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Supabase first
  final supabase = await Supabase.initialize(
    url: AppSecret.supabaseUrl,
    anonKey: AppSecret.supabaseAnonKey,
  );

  // Initialize Hive
  // For Flutter apps, use initFlutter() which automatically uses the app's documents directory
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  
  // ✅ Open the Hive box before registering it
  // This ensures the box is ready when it's accessed
  final blogsBox = await Hive.openBox('blogs');

  // Register core dependencies BEFORE calling _initAuth and _initBlog
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => InternetConnection());
  serviceLocator.registerLazySingleton<Box>(() => blogsBox);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  
  // Register InternetChecker with the interface type
  serviceLocator.registerFactory<InternetChecker>(
    () => InternetCheckerImpl(serviceLocator()),
  );

  // Now initialize auth and blog (they depend on the above)
  _initAuth();
  _initBlog();
}

void _initAuth() {
  serviceLocator
    // Data Source
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // Use Cases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserSignIn(serviceLocator()))
    ..registerFactory(() => UserLogout(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        currentUser: serviceLocator<CurrentUser>(),
        userSignUp: serviceLocator<UserSignUp>(),
        userSignIn: serviceLocator<UserSignIn>(),
        appUserCubit: serviceLocator<AppUserCubit>(),
        userLogout: serviceLocator<UserLogout>(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    // Data Source
    // Remote
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    // Local
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Use Cases
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlog(serviceLocator()))
    ..registerFactory(() => DeleteBlog(serviceLocator()))
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator<UploadBlog>(),
        getAllBlogs: serviceLocator<GetAllBlog>(),
        deleteBlog: serviceLocator<DeleteBlog>(),
      ),
    );
}

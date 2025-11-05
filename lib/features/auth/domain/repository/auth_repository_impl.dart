import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/error/server_exception.dart';
import 'package:blog_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  AuthRepositoryImpl(this.authRemoteDataSourceImpl);
  @override
  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userId = await authRemoteDataSourceImpl.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      right(userId);
    } on ServerException catch (e) {
      left(Failure(e.toString()));
    }
    throw UnimplementedError();
  }
}

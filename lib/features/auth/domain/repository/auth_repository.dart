import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> currentUser();
}

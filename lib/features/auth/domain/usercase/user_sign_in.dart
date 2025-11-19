import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements UseCase<UserEntity, UserSignInParams> {
  final AuthRepository _authRepository;
  UserSignIn(this._authRepository);
  @override
  Future<Either<Failure, UserEntity>> call(UserSignInParams params) async {
    return await _authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;
  UserSignInParams({required this.email, required this.password});
}

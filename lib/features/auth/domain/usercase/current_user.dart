import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<UserEntity, NoParams> {
  final AuthRepository _authRepository;
  CurrentUser(this._authRepository);
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await _authRepository.currentUser();
  }
}

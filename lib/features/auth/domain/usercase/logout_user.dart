import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogout implements UseCase<Unit, NoParams> {
  final AuthRepository _authRepository;
  UserLogout(this._authRepository);
  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _authRepository.logout();
  }
}

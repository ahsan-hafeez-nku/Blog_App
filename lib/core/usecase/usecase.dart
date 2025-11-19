import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessState, Params> {
  Future<Either<Failure, SuccessState>> call(Params params);
}

abstract interface class UseCaseNoParams<SuccessState> {
  Future<Either<Failure, SuccessState>> call();
}

class NoParams {}

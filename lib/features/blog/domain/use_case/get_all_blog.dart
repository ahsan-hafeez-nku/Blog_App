import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlog implements UseCase<List<BlogEntity>, NoParams> {
  final BlogRepository _blogRepository;
  GetAllBlog(this._blogRepository);
  @override
  Future<Either<Failure, List<BlogEntity>>> call(NoParams params) async {
    return await _blogRepository.getAllBlogs();
  }
}

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<Unit, DeleteBlogParams> {
  final BlogRepository _blogRepository;
  DeleteBlog(this._blogRepository);
  @override
  Future<Either<Failure, Unit>> call(DeleteBlogParams params) async {
    return await _blogRepository.deleteBlog(blogId: params.id);
  }
}

class DeleteBlogParams {
  final String id;

  DeleteBlogParams({required this.id});
}

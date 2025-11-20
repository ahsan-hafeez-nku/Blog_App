import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<BlogEntity, UploadBlogParams> {
  final BlogRepository _blogRepository;
  UploadBlog(this._blogRepository);
  @override
  Future<Either<Failure, BlogEntity>> call(UploadBlogParams params) async {
    return await _blogRepository.uploadBlog(
      content: params.content,
      title: params.title,
      image: params.image,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;

  UploadBlogParams({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}

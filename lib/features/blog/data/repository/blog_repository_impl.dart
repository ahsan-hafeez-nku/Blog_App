import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/error/server_exception.dart';
import 'package:blog_app/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  BlogRemoteDataSource blogRemoteDataSource;
  BlogRepositoryImpl(this.blogRemoteDataSource);
  @override
  Future<Either<Failure, BlogEntity>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blog = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blog,
      );
      blog = blog.copyWith(imageUrl: imageUrl);
      final response = await blogRemoteDataSource.uploadBlog(blog: blog);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

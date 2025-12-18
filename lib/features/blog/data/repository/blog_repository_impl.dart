import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/error/server_exception.dart';
import 'package:blog_app/core/network/internet_checker.dart';
import 'package:blog_app/features/blog/data/data_source/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  InternetChecker internetChecker;
  BlogRemoteDataSource blogRemoteDataSource;
  BlogLocalDataSource blogLocalDataSource;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.internetChecker,
  );
  @override
  Future<Either<Failure, BlogEntity>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      log(
        "Intennet Connection Checker: ${internetChecker.isConnected.toString()}",
      );
      if (!await internetChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      final blogId = const Uuid().v1();
      final fileExt = image.path.split('.').last;
      final imageFileName = '$blogId.$fileExt';

      BlogModel blog = BlogModel(
        id: blogId,
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        filePath: imageFileName,
      );

      blog = blog.copyWith(imageUrl: imageUrl);
      final response = await blogRemoteDataSource.uploadBlog(blog: blog);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> getAllBlogs() async {
    try {
      if (!await internetChecker.isConnected) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
        // return left(Failure('No internet connection'));
      }
      final response = await blogRemoteDataSource.getAllBlogs();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBlog({required String blogId}) async {
    try {
      await blogRemoteDataSource.deleteBlog(blogId: blogId);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

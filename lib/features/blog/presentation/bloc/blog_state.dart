part of 'blog_bloc.dart';

sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogUploadSuccess extends BlogState {
  BlogEntity blog;
  BlogUploadSuccess(this.blog);
}

final class BlogDisplaySuccess extends BlogState {
  List<BlogEntity> blogList;
  BlogDisplaySuccess(this.blogList);
}

final class BlogDeleteSuccess extends BlogState {}

final class BlogFailure extends BlogState {
  final String message;
  BlogFailure(this.message);
}

part of 'blog_bloc.dart';

sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogSuccess extends BlogState {
  BlogEntity blog;
  BlogSuccess(this.blog);
}

final class BlogFailure extends BlogState {
  final String message;
  BlogFailure(this.message);
}

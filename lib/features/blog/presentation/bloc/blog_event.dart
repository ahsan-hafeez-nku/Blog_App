part of 'blog_bloc.dart';

sealed class BlogEvent {}

class BlogUpload extends BlogEvent {
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;

  BlogUpload({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}

class FetchAllBlogs extends BlogEvent {
  FetchAllBlogs();
}

class DeleteBlogFromDB extends BlogEvent {
  final String blogId;
  DeleteBlogFromDB({required this.blogId});
}

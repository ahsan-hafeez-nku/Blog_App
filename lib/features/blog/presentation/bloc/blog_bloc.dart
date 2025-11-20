import 'package:blog_app/features/blog/domain/use_case/upload_blog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  BlogBloc({required UploadBlog uploadBlog})
    : _uploadBlog = uploadBlog,

      super(BlogInitial()) {
    on<BlogEvent>((event, emit) {});
  }
}

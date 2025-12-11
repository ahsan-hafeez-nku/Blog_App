import 'dart:io';

import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:blog_app/features/blog/domain/use_case/upload_blog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  BlogBloc({required UploadBlog uploadBlog})
    : _uploadBlog = uploadBlog,

      super(BlogInitial()) {
    on<BlogEvent>((_, emit) => emit(BlogLoading()));
    on<BlogUpload>(_blogUploadFunc);
  }
  void _blogUploadFunc(BlogUpload event, Emitter<BlogState> emit) async {
    try {
      final res = await _uploadBlog.call(
        UploadBlogParams(
          image: event.image,
          title: event.title,
          content: event.content,
          posterId: event.posterId,
          topics: event.topics,
        ),
      );
      res.fold(
        (l) => emit(BlogFailure(l.message)),
        (r) => emit(BlogSuccess(r)),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }
}

import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:blog_app/features/blog/domain/use_case/delete_blog.dart';
import 'package:blog_app/features/blog/domain/use_case/get_all_blog.dart';
import 'package:blog_app/features/blog/domain/use_case/upload_blog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlog _getAllBlogs;
  final DeleteBlog _deleteBlog;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlog getAllBlogs,
    required DeleteBlog deleteBlog,
  }) : _uploadBlog = uploadBlog,
       _getAllBlogs = getAllBlogs,
       _deleteBlog = deleteBlog,

       super(BlogInitial()) {
    on<BlogEvent>((_, emit) => emit(BlogLoading()));
    on<BlogUpload>(_blogUploadFunc);
    on<FetchAllBlogs>(_getAllBlogsFunc);
    on<DeleteBlogFromDB>(_deleteBlogFunc);
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
        (r) => emit(BlogUploadSuccess(r)),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }

  void _getAllBlogsFunc(FetchAllBlogs event, Emitter<BlogState> emit) async {
    try {
      final res = await _getAllBlogs.call(NoParams());
      res.fold(
        (l) => emit(BlogFailure(l.message)),
        (r) => emit(BlogDisplaySuccess(r)),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }

  void _deleteBlogFunc(DeleteBlogFromDB event, Emitter<BlogState> emit) async {
    try {
      final res = await _deleteBlog.call(DeleteBlogParams(id: event.blogId));
      res.fold(
        (l) => emit(BlogFailure(l.message)),
        (r) => emit(BlogDeleteSuccess()),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }
}

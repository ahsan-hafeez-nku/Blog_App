import 'dart:developer';

import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  List<BlogModel> loadBlogs();
  void saveBlogs(List<BlogModel> blogs);
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    for (int i = 0; i < box.length; i++) {
      try {
        final data = box.getAt(i);
        if (data != null) {
          blogs.add(BlogModel.fromJson(data));
        }
      } catch (e) {
        log('BlogLocalDataSource: Error loading blog at index $i: $e');
      }
    }

    return blogs;
  }

  @override
  void saveBlogs(List<BlogModel> blogs) {
    box.clear();
    box.addAll(blogs.map((blog) => blog.toJson()).toList());
  }
}

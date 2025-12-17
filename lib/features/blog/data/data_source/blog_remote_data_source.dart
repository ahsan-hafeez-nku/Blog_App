import 'dart:io';

import 'package:blog_app/core/error/server_exception.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog({required BlogModel blog});

  Future<String> uploadBlogImage({
    required File image,
    required String filePath,
  });

  Future<List<BlogModel>> getAllBlogs();

  Future<void> deleteBlog({required String blogId});
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog({required BlogModel blog}) async {
    try {
      final res = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select()
          .single();

      return BlogModel.fromJson(res);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required String filePath,
  }) async {
    try {
      await supabaseClient.storage
          .from('blog_images')
          .upload(
            filePath,
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return supabaseClient.storage.from('blog_images').getPublicUrl(filePath);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, userprofiles(name)');

      return blogs.map<BlogModel>((blog) {
        return BlogModel.fromJson(
          blog,
        ).copyWith(posterName: blog['userprofiles']?['name'] as String?);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteBlog({required String blogId}) async {
    try {
      final blog = await supabaseClient
          .from('blogs')
          .select('image_url')
          .eq('id', blogId)
          .single();

      final imageUrl = blog['image_url'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final filePath = _extractStoragePath(imageUrl);
        await supabaseClient.storage.from('blog_images').remove([filePath]);
      }
      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Converts full public URL → storage file path
  String _extractStoragePath(String url) {
    final uri = Uri.parse(url);
    final index = uri.pathSegments.indexOf('blog_images');

    if (index == -1 || index + 1 >= uri.pathSegments.length) {
      throw Exception('Invalid storage URL');
    }

    return uri.pathSegments.sublist(index + 1).join('/');
  }
}

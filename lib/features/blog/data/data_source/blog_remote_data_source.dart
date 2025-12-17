import 'dart:io';

import 'package:blog_app/core/error/server_exception.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog({required BlogModel blog});
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
    required String fileName,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<void> deleteBlog({required String blogId});
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  SupabaseClient supabaseClient;
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
    required BlogModel blog,
    required String fileName, // Add this parameter
  }) async {
    try {
      // Upload to Supabase with the filename that includes extension
      await supabaseClient.storage
          .from('blog_images')
          .upload(
            fileName,
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get the public URL
      final imageUrl = supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(fileName);

      return imageUrl;
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

      return blogs.map((blog) {
        final posterName = (blog['userprofiles'] != null)
            ? blog['userprofiles']['name'] as String
            : 'Unknown';
        return BlogModel.fromJson(blog).copyWith(posterName: posterName);
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteBlog({required String blogId}) async {
    try {
      // 1️⃣ Fetch image_url first
      final blog = await supabaseClient
          .from('blogs')
          .select('image_url')
          .eq('id', blogId)
          .single();

      final imageUrl = blog['image_url'] as String?;

      // 2️⃣ Delete image from storage if exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final filePath = _extractStoragePath(imageUrl);
          print('🗑️ Attempting to delete image: $filePath');
          print('   From URL: $imageUrl');
          
          final result = await supabaseClient.storage
              .from('blog_images')
              .remove([filePath]);
          
          print('✅ Image deleted successfully: $result');
        } catch (storageError) {
          // Log storage error but don't fail the entire delete operation
          print('⚠️ Failed to delete image from storage: $storageError');
          print('   Continuing to delete blog entry...');
          // Don't throw - continue to delete blog entry even if image delete fails
        }
      } else {
        print('ℹ️ No image URL found, skipping storage deletion');
      }

      // 3️⃣ Delete blog row from database
      print('🗑️ Deleting blog entry from database: $blogId');
      await supabaseClient.from('blogs').delete().eq('id', blogId);
      print('✅ Blog entry deleted successfully');
    } catch (e) {
      print('❌ Delete blog failed: $e');
      throw ServerException(message: 'Failed to delete blog: ${e.toString()}');
    }
  }

  /// Extract the storage file path from a full Supabase storage URL
  /// 
  /// Example:
  /// Input:  https://xxx.supabase.co/storage/v1/object/public/blog_images/uuid.jpg
  /// Output: uuid.jpg
  String _extractStoragePath(String url) {
    try {
      final uri = Uri.parse(url);
      
      // Find the index of 'blog_images' in path segments
      final segments = uri.pathSegments;
      final blogImagesIndex = segments.indexOf('blog_images');
      
      if (blogImagesIndex == -1 || blogImagesIndex >= segments.length - 1) {
        throw Exception('Invalid URL structure: blog_images not found or no file path after it');
      }
      
      // Get all segments after 'blog_images'
      final filePath = segments.sublist(blogImagesIndex + 1).join('/');
      
      if (filePath.isEmpty) {
        throw Exception('No file path found in URL');
      }
      
      return filePath;
    } catch (e) {
      print('❌ Error extracting storage path from URL: $url');
      print('   Error: $e');
      rethrow;
    }
  }
}

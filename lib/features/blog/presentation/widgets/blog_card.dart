import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final BlogEntity blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 200, child: Text(blog.title));
  }
}

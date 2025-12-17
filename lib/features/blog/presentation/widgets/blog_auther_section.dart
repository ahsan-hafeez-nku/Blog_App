import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:flutter/material.dart';

class BlogAuthorSection extends StatelessWidget {
  final BlogEntity blog;

  const BlogAuthorSection({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          child: Text(blog.posterName?.substring(0, 1).toUpperCase() ?? 'U'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(blog.posterName ?? 'Unknown Author'),
            Text(formatDate(blog.updatedAt)),
          ],
        ),
      ],
    );
  }
}

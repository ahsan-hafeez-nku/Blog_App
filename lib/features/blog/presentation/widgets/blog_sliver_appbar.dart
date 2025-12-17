import 'package:blog_app/features/blog/presentation/widgets/blog_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entity/blog_entity.dart';

class BlogSliverAppBar extends StatelessWidget {
  final BlogEntity blog;
  final bool showTitle;

  const BlogSliverAppBar({
    super.key,
    required this.blog,
    required this.showTitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      expandedHeight: size.height * 0.45,
      pinned: true,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Icon(Icons.arrow_back_ios_new),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: AnimatedOpacity(
          opacity: showTitle ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Text(blog.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        background: BlogImage(imageUrl: blog.imageUrl, blogId: blog.id),
      ),
    );
  }
}

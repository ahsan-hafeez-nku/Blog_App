import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/confirmation_dialog_delete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      backgroundColor: AppColors.borderColor,
      expandedHeight: size.height * 0.45,
      pinned: true,

      /// Back button
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.5),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),

      /// Delete action
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () async {
                final shouldDelete = await showDeleteConfirmation(
                  context: context,
                  title: 'Delete Blog',
                  content: 'Are you sure you want to delete this blog?',
                );

                if (shouldDelete == true) {
                  if (!context.mounted) return;

                  context.read<BlogBloc>().add(
                    DeleteBlogFromDB(blogId: blog.id),
                  );

                  context.pop();
                }
              },
            ),
          ),
        ),
      ],

      flexibleSpace: FlexibleSpaceBar(
        title: AnimatedOpacity(
          opacity: showTitle ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            blog.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
        background: BlogImage(imageUrl: blog.imageUrl, blogId: blog.id),
      ),
    );
  }
}

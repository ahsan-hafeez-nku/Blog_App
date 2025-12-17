import 'dart:developer';

import 'package:blog_app/core/font/app_font.dart';
import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/confirmation_dialog_delete.dart';
import 'package:blog_app/features/blog/presentation/widgets/topic_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlogCard extends StatelessWidget {
  final BlogEntity blog;
  final Color color;

  const BlogCard({super.key, required this.color, required this.blog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('onTap');
        context.push(RouteEndpoints.blogViewerScreen, extra: blog);
      },
      child: Dismissible(
        key: ValueKey(blog.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDeleteConfirmation(
            context: context,
            title: 'Delete Blog',
            content: 'Are you sure you want to delete this blog?',
          );
        },
        onDismissed: (_) {
          context.read<BlogBloc>().add(DeleteBlogFromDB(blogId: blog.id));
        },

        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopicSelector(
                selectedTopics: blog.topics,
                onTopicToggle: (_) {},
                onlyShowSelectedTopics: true,
              ),
              const SizedBox(height: 10),
              Text(
                blog.title,
                style: AppFonts.bold28(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                formatDate(blog.updatedAt),
                style: AppFonts.medium16(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

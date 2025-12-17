import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/core/font/app_font.dart';
import 'package:blog_app/features/blog/domain/entity/blog_entity.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_auther_section.dart';
import 'package:blog_app/features/blog/presentation/widgets/topic_selector.dart';
import 'package:flutter/material.dart';

class BlogContentSection extends StatelessWidget {
  final BlogEntity blog;

  const BlogContentSection({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopicSelector(
            selectedTopics: blog.topics,
            onTopicToggle: (_) {},
            onlyShowSelectedTopics: true,
          ),
          const SizedBox(height: 20),
          Text(blog.title, style: AppFonts.medium32()),
          const SizedBox(height: 20),
          BlogAuthorSection(blog: blog),
          const Divider(),
          Text(
            blog.content,
            style: AppFonts.light24(color: AppColors.greyColor),
          ),
        ],
      ),
    );
  }
}

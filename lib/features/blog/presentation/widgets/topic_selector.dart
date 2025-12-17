import 'package:blog_app/core/color/app_color.dart';
import 'package:flutter/material.dart';

class TopicSelector extends StatelessWidget {
  final List<String> availableTopics;
  final List<String> selectedTopics;
  final bool onlyShowSelectedTopics;
  final Function(String topic) onTopicToggle;

  const TopicSelector({
    super.key,
    required this.selectedTopics,
    required this.onTopicToggle,
    this.onlyShowSelectedTopics = false,
    this.availableTopics = const [
      'Technology',
      'Business',
      'Programming',
      'Entertainment',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: onlyShowSelectedTopics
            ? selectedTopics
                  .map(
                    (topic) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Chip(
                        color: WidgetStateProperty.all(Colors.black),
                        label: Text(topic),
                        side: BorderSide(color: AppColors.borderColor),
                      ),
                    ),
                  )
                  .toList() // ✅ Added .toList() here
            : availableTopics
                  .map(
                    (topic) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => onTopicToggle(topic),
                        child: Chip(
                          color: selectedTopics.contains(topic)
                              ? WidgetStateProperty.all(AppColors.gradient2)
                              : null,
                          label: Text(topic),
                          side: BorderSide(color: AppColors.borderColor),
                        ),
                      ),
                    ),
                  )
                  .toList(),
      ),
    );
  }
}

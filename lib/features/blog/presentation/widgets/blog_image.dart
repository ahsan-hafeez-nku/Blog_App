import 'package:blog_app/core/color/app_color.dart';
import 'package:flutter/material.dart';

class BlogImage extends StatelessWidget {
  final String imageUrl;
  final String blogId;

  const BlogImage({super.key, required this.imageUrl, required this.blogId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        /// Blog Image
        Hero(
          tag: 'blog_image_$blogId',
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: AppColors.gradient2,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.gradient2,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white70,
                    size: 80,
                  ),
                ),
              );
            },
          ),
        ),

        /// Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
        ),
      ],
    );
  }
}

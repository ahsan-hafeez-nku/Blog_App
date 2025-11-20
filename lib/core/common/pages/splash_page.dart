import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/core/utils/loader.dart';
import 'package:blog_app/core/font/app_font.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradient1,
              AppColors.gradient2,
              AppColors.gradient3,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_outlined, size: 80, color: Colors.white),
              SizedBox(height: 24),
              Text('Blog App', style: AppFonts.bold36(color: Colors.white)),
              SizedBox(height: 48),
              Loader(),
            ],
          ),
        ),
      ),
    );
  }
}

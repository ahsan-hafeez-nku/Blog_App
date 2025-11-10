import 'package:blog_app/core/font/app_font.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, {Color? color}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text, style: AppFonts.medium16(color: Colors.white)),
        backgroundColor: color ?? Colors.black87,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
}

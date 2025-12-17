import 'dart:io';

import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/core/font/app_font.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ImageSelector extends StatelessWidget {
  final File? image;
  final VoidCallback onSelectImage;
  final VoidCallback onRemoveImage;

  const ImageSelector({
    super.key,
    required this.image,
    required this.onSelectImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onSelectImage,
      child: image != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    image!,
                    height: size.height * 0.2,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: onRemoveImage,
                    ),
                  ),
                ),
              ],
            )
          : DottedBorder(
              options: RoundedRectDottedBorderOptions(
                dashPattern: [10, 4],
                radius: Radius.circular(10),
                color: AppColors.greyColor,
              ),
              child: SizedBox(
                width: double.infinity,
                height: size.height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.folder_open_rounded, size: 50),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      'Select your image',
                      style: AppFonts.bold20(color: AppColors.greyColor),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

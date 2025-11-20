import 'dart:io';

import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/core/font/app_font.dart';
import 'package:blog_app/core/utils/image_picker.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final selectedTopics = <String>[];
  File? image;
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  void selectImage() async {
    final pickedImage = await pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
        ),

        body: SingleChildScrollView(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => selectImage(),

                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          image!,
                          height: size.height * 0.2,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
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
                              Icon(Icons.folder_open_rounded, size: 50),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                'Select your image',
                                style: AppFonts.bold20(
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              SizedBox(height: size.height * 0.02),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children:
                      ['Technology', 'Business', 'Programming', 'Entertainment']
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                if (selectedTopics.contains(e)) {
                                  selectedTopics.remove(e);
                                } else {
                                  selectedTopics.add(e);
                                }
                                setState(() {});
                              },
                              child: Chip(
                                color: selectedTopics.contains(e)
                                    ? WidgetStateProperty.all(
                                        AppColors.gradient2,
                                      )
                                    : null,
                                label: Text(e),
                                side: BorderSide(color: AppColors.borderColor),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              BlogEditorWidget(controller: titleController, hintText: "Title"),
              SizedBox(height: size.height * 0.01),

              BlogEditorWidget(
                controller: contentController,
                hintText: "Content",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

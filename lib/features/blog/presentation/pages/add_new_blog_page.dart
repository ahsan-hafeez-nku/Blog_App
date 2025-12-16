import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/core/common/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:blog_app/core/font/app_font.dart';
import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:blog_app/core/utils/image_picker.dart';
import 'package:blog_app/core/utils/snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final selectedTopics = <String>[];
  File? image;
  bool _isUploading = false;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void selectImage() async {
    try {
      log('📸 Attempting to select image from gallery');
      final pickedImage = await pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        log('✅ Image selected successfully: ${pickedImage.path}');
        log('📊 Image size: ${await pickedImage.length()} bytes');

        setState(() {
          image = pickedImage;
        });
      } else {
        log('⚠️ No image selected by user');
      }
    } catch (e, stackTrace) {
      log('❌ Error selecting image: $e');
      log('Stack trace: $stackTrace');

      if (mounted) {
        showSnackBar(context, 'Failed to select image. Please try again.');
      }
    }
  }

  void uploadBlog() {
    log('🚀 Upload blog initiated');

    // Prevent multiple uploads
    if (_isUploading) {
      log('⚠️ Upload already in progress, ignoring request');
      showSnackBar(context, 'Upload already in progress');
      return;
    }

    // Validate image
    if (image == null) {
      log('❌ Validation failed: No image selected');
      showSnackBar(context, 'Please select an image for your blog');
      return;
    }

    // Validate topics
    if (selectedTopics.isEmpty) {
      log('❌ Validation failed: No topics selected');
      showSnackBar(context, 'Please select at least one topic');
      return;
    }

    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      log('❌ Validation failed: Form validation failed');
      showSnackBar(context, 'Please fill in all required fields');
      return;
    }

    // Validate user state
    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      log('❌ Validation failed: User not logged in');
      showSnackBar(context, 'Please log in to upload a blog');
      return;
    }

    try {
      final title = titleController.text.trim();
      final content = contentController.text.trim();

      log('✅ All validations passed');
      log('📝 Blog details:');
      log('   - Title: $title (${title.length} chars)');
      log('   - Content: ${content.length} chars');
      log('   - Topics: ${selectedTopics.join(", ")}');
      log('   - Image: ${image!.path}');
      log('   - Poster ID: ${userState.user.id}');

      setState(() {
        _isUploading = true;
      });

      context.read<BlogBloc>().add(
        BlogUpload(
          image: image!,
          title: title,
          content: content,
          posterId: userState.user.id,
          topics: selectedTopics,
        ),
      );

      log('✅ Blog upload event dispatched to bloc');
    } catch (e, stackTrace) {
      log('❌ Error during upload: $e');
      log('Stack trace: $stackTrace');

      setState(() {
        _isUploading = false;
      });

      if (mounted) {
        showSnackBar(context, 'Failed to upload blog. Please try again.');
      }
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      log('⚠️ Title validation failed: Empty');
      return 'Title is required';
    }
    if (value.trim().length < 3) {
      log(
        '⚠️ Title validation failed: Too short (${value.trim().length} chars)',
      );
      return 'Title must be at least 3 characters';
    }
    if (value.trim().length > 100) {
      log(
        '⚠️ Title validation failed: Too long (${value.trim().length} chars)',
      );
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      log('⚠️ Content validation failed: Empty');
      return 'Content is required';
    }
    if (value.trim().length < 10) {
      log(
        '⚠️ Content validation failed: Too short (${value.trim().length} chars)',
      );
      return 'Content must be at least 10 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log('🎨 Building AddNewBlogPage');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            log('🔙 Back button pressed');
            if (_isUploading) {
              log('⚠️ Upload in progress, confirming navigation');
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Upload in Progress'),
                  content: const Text(
                    'Are you sure you want to cancel the upload?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.pop();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            } else {
              context.pop();
            }
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: _isUploading ? null : uploadBlog,
            icon: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            log('📡 Blog state changed: ${state.runtimeType}');

            if (state is BlogLoading) {
              log('⏳ Blog upload loading...');
            } else if (state is BlogSuccess) {
              log('✅ Blog upload successful!');

              setState(() {
                _isUploading = false;
              });

              showSnackBar(context, 'Blog uploaded successfully!');
              context.goNamed(RouteEndpoints.homeName);
            } else if (state is BlogFailure) {
              log('❌ Blog upload failed: ${state.message}');

              setState(() {
                _isUploading = false;
              });

              showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            return AbsorbPointer(
              absorbing: _isUploading,
              child: Opacity(
                opacity: _isUploading ? 0.5 : 1.0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: selectImage,
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
                                          onPressed: () {
                                            log('🗑️ Removing selected image');
                                            setState(() {
                                              image = null;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : DottedBorder(
                                  // dashPattern: const [10, 4],
                                  // radius: const Radius.circular(10),
                                  // color: AppColors.greyColor,
                                  // borderType: BorderType.RRect,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: size.height * 0.2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.folder_open_rounded,
                                          size: 50,
                                        ),
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
                            children:
                                [
                                      'Technology',
                                      'Business',
                                      'Programming',
                                      'Entertainment',
                                    ]
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (selectedTopics.contains(e)) {
                                              log('➖ Topic removed: $e');
                                              selectedTopics.remove(e);
                                            } else {
                                              log('➕ Topic added: $e');
                                              selectedTopics.add(e);
                                            }
                                            log(
                                              '📋 Selected topics: ${selectedTopics.join(", ")}',
                                            );
                                            setState(() {});
                                          },
                                          child: Chip(
                                            color: selectedTopics.contains(e)
                                                ? WidgetStateProperty.all(
                                                    AppColors.gradient2,
                                                  )
                                                : null,
                                            label: Text(e),
                                            side: BorderSide(
                                              color: AppColors.borderColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        BlogEditorWidget(
                          controller: titleController,
                          hintText: "Title",
                          // validator: validateTitle,
                        ),
                        SizedBox(height: size.height * 0.01),
                        BlogEditorWidget(
                          controller: contentController,
                          hintText: "Content",
                          // validator: validateContent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

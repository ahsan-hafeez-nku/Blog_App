import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/common/cubit/app_user_cubit/app_user_cubit.dart';
import 'package:blog_app/core/utils/image_picker.dart';
import 'package:blog_app/core/utils/loader.dart';
import 'package:blog_app/core/utils/snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:blog_app/features/blog/presentation/widgets/image_selector.dart';
import 'package:blog_app/features/blog/presentation/widgets/topic_selector.dart';
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

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void selectImage() async {
    try {
      final pickedImage = await pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          image = pickedImage;
        });
      }
    } catch (e, stackTrace) {
      log('Stack trace: $stackTrace');

      if (mounted) {
        showSnackBar(context, 'Failed to select image. Please try again.');
      }
    }
  }

  void removeImage() {
    setState(() {
      image = null;
    });
  }

  void toggleTopic(String topic) {
    setState(() {
      if (selectedTopics.contains(topic)) {
        selectedTopics.remove(topic);
      } else {
        selectedTopics.add(topic);
      }
    });
  }

  void uploadBlog() {
    if (image == null) {
      showSnackBar(context, 'Please select an image for your blog');
      return;
    }
    if (selectedTopics.isEmpty) {
      showSnackBar(context, 'Please select at least one topic');
      return;
    }
    if (!_formKey.currentState!.validate()) {
      showSnackBar(context, 'Please fill in all required fields');
      return;
    }
    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      showSnackBar(context, 'Please log in to upload a blog');
      return;
    }
    try {
      final title = titleController.text.trim();
      final content = contentController.text.trim();
      context.read<BlogBloc>().add(
        BlogUpload(
          image: image!,
          title: title,
          content: content,
          posterId: userState.user.id,
          topics: selectedTopics,
        ),
      );
    } catch (e, stackTrace) {
      log('Stack trace: $stackTrace');
      if (mounted) {
        showSnackBar(context, 'Failed to upload blog. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              return IconButton(
                onPressed: state is BlogLoading ? null : uploadBlog,
                icon: state is BlogLoading
                    ? const Loader()
                    : const Icon(Icons.check),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
         child: BlocConsumer<BlogBloc, BlogState>(
           listener: (context, state) {
             if (state is BlogUploadSuccess) {
               showSnackBar(context, 'Blog uploaded successfully!');
               // ✅ Just navigate back, blog_page will handle the refresh
               context.goNamed('home');
             } else if (state is BlogFailure) {
               showSnackBar(context, state.message);
             }
           },
          builder: (context, state) {
            return AbsorbPointer(
              absorbing: state is BlogLoading,
              child: Opacity(
                opacity: state is BlogLoading ? 0.5 : 1.0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ImageSelector(
                          image: image,
                          onSelectImage: selectImage,
                          onRemoveImage: removeImage,
                        ),
                        SizedBox(height: size.height * 0.02),
                        TopicSelector(
                          selectedTopics: selectedTopics,
                          onTopicToggle: toggleTopic,
                        ),
                        SizedBox(height: size.height * 0.02),
                        BlogEditorWidget(
                          controller: titleController,
                          hintText: "Title",
                        ),
                        SizedBox(height: size.height * 0.01),
                        BlogEditorWidget(
                          controller: contentController,
                          hintText: "Content",
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

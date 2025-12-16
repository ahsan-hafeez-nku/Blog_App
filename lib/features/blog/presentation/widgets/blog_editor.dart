import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlogEditorWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const BlogEditorWidget({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(
          hintText == 'Title'
              ? 50
              : hintText == 'Content'
              ? 200
              : 100,
        ),
      ],
      decoration: InputDecoration(hintText: hintText),
      maxLines: null,
      validator: (value) {
        if ((value == null || value.trim().isEmpty)) {
          return '$hintText is required';
        } else if ((hintText == 'Title') && (value.trim().length < 3)) {
          return 'Title must be at least 3 characters';
        } else if ((hintText == 'Content') && value.trim().length < 10) {
          return 'Content must be at least 10 characters';
        }
        return null;
      },
    );
  }
}

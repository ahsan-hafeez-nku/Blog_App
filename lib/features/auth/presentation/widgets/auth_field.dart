import 'package:flutter/material.dart';

final emailRegex = RegExp(r'^[^@]+@[^@]+$');

class AuthField extends StatelessWidget {
  final String hintText;
  final String type;
  final TextEditingController controller;
  final bool isObscureText;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.type = '',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        } else if (emailRegex.hasMatch(controller.text) == false &&
            hintText == 'Email' &&
            type == 'email') {
          return "Invalid email";
        } else if (value.length < 6 &&
            hintText == 'Password' &&
            type == 'password') {
          return "Passowrd Must be 6 characters long";
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}

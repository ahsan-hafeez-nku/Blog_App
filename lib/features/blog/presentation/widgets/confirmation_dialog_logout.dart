import 'package:flutter/material.dart';

Future<bool?> showLogoutConfirmation({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onLogout,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onLogout,
          child: const Text('Logout', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

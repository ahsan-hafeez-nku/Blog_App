import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Column(
            children: [
              DottedBorder(
                options: CircularDottedBorderOptions(color: Colors.grey),
                child: Container(height: 150),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

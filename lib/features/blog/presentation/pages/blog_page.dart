import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              // context.push(RouteEndpoints.addBlogScreen);
              context.push(RouteEndpoints.addBlogScreen);
            },
            icon: Icon(Icons.add_circle_outline_outlined),
          ),
        ],
      ),
    );
  }
}

              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => const AddNewBlogPage()),
              // );
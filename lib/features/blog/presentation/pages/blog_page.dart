import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/core/font/app_font.dart';
import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:blog_app/core/utils/loader.dart';
import 'package:blog_app/core/utils/snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(FetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              context.push(RouteEndpoints.addBlogScreen);
            },
            icon: Icon(Icons.add_circle_outline_outlined),
          ),
        ],
        scrolledUnderElevation: 0,
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          } else if (state is BlogDeleteSuccess) {
            showSnackBar(context, 'Blog deleted successfully');
            context.read<BlogBloc>().add(FetchAllBlogs());
          } else if (state is BlogUploadSuccess) {
            context.read<BlogBloc>().add(FetchAllBlogs());
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          } else if (state is BlogDisplaySuccess) {
            return state.blogList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No blogs yet',
                          style: AppFonts.bold20(color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Create your first blog post',
                          style: AppFonts.medium16(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.blogList.length,
                    itemBuilder: (context, index) {
                      return BlogCard(
                        blog: state.blogList[index],
                        color: index % 3 == 0
                            ? AppColors.gradient1
                            : index % 3 == 1
                            ? AppColors.greyColor
                            : AppColors.gradient2,
                      );
                    },
                  );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

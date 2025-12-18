import 'dart:developer';

import 'package:blog_app/core/color/app_color.dart';
import 'package:blog_app/core/font/app_font.dart';
import 'package:blog_app/core/routes/routes_endpoints.dart';
import 'package:blog_app/core/utils/failure_widget.dart';
import 'package:blog_app/core/utils/loader.dart';
import 'package:blog_app/core/utils/snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';

import 'package:blog_app/features/blog/presentation/widgets/confirmation_dialog_logout.dart';
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
          IconButton(
            onPressed: () {
              showLogoutConfirmation(
                context: context,
                title: 'Logout',
                content: "Are you sure you want to logout?",
                onLogout: () {
                  log('Logout Pressed');
                  context.read<AuthBloc>().add(AuthUserLogout());
                  context.pop();
                },
              );
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
        scrolledUnderElevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          // Listen to BlogBloc
          BlocListener<BlogBloc, BlogState>(
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
          ),

          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLogoutSuccess) {
                context.goNamed(RouteEndpoints.loginName);
              } else if (state is AuthFailure) {
                log("Auth Bloc Logout Failure: ${state.message}");
                showSnackBar(context, 'Logout failed: ${state.message}');
              }
            },
          ),
        ],
        child: BlocBuilder<BlogBloc, BlogState>(
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
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<BlogBloc>().add(FetchAllBlogs());
                      },
                      child: ListView.builder(
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
                      ),
                    );
            } else if (state is BlogFailure) {
              final isNoInternet = state.message == 'No internet connection';

              return FailureWidget(
                isNoInternet: isNoInternet,
                message: state.message,
                onRetry: () {
                  context.read<BlogBloc>().add(FetchAllBlogs());
                },
              );
            }
            return const SizedBox();
          },
          // },
        ),
      ),
    );
  }
}

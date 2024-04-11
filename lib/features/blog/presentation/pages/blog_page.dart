import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/core/common/widgets/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_blog.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late User userModel;
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(GetAllBlog());
    userModel = (context.read<AuthBloc>().state as AuthSuccess).user;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
          IconButton(
            onPressed: () {
              context.read<BlogBloc>().add(UserLogout());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
            context.read<BlogBloc>().add(GetAllBlog());
          }
          if (state is UserLogOutSuccess) {
            Navigator.pushAndRemoveUntil(
                context, SignInPage.route(), (route) => false);
          }
          if (state is BlogDeleteSuccess) {
            context.read<BlogBloc>().add(GetAllBlog());
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<BlogBloc>().add(GetAllBlog());
              },
              child: ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  return BlogCard(
                    blog: state.blogs[index],
                    color: index % 3 == 0
                        ? AppPallete.gradient1
                        : AppPallete.gradient2,
                    userId: userModel.id,
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}

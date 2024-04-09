import 'dart:io';

import 'package:blog_app/core/common/widgets/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/secrets/secrets.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pic_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/edit_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBlogPage extends StatefulWidget {
  static route(blog) => MaterialPageRoute(
        builder: (_) => EditBlogPage(
          blog: blog,
        ),
      );
  final Blog blog;
  const EditBlogPage({super.key, required this.blog});

  @override
  State<EditBlogPage> createState() => _EditBlogPageState();
}

class _EditBlogPageState extends State<EditBlogPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  List<String> selectedTopics = [];
  File? image;
  String networkImageUrl = "";

  @override
  void initState() {
    super.initState();
    titleController.text = widget.blog.title;
    descriptionController.text = widget.blog.content;
    networkImageUrl = widget.blog.imageUrl;
    selectedTopics = widget.blog.topics;
  }

  void selectImage() async {
    File? file = await pickImage();
    if (file != null) {
      setState(() {
        image = file;
      });
    }
  }

  uploadBlog() async {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(EditBlogBloc(
            id: widget.blog.id,
            image: image!,
            title: titleController.text.trim(),
            content: descriptionController.text.trim(),
            posterId: userId,
            topics: selectedTopics,
          ));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Blog"),
        actions: [
          IconButton(onPressed: uploadBlog, icon: const Icon(Icons.done)),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          }
          if (state is BlogEditSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : networkImageUrl != ""
                            ? GestureDetector(
                                onTap: selectImage,
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Image.network(
                                    networkImageUrl,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: DottedBorder(
                                  color: AppPallete.borderColor,
                                  dashPattern: const [15, 4],
                                  radius: const Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  strokeCap: StrokeCap.round,
                                  child: const SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_open,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Select your image",
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Programming',
                          'Gaming',
                          'Current Affair',
                        ]
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopics.contains(e)) {
                                        selectedTopics.remove(e);
                                      } else {
                                        selectedTopics.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                      color: selectedTopics.contains(e)
                                          ? const MaterialStatePropertyAll(
                                              AppPallete.gradient1)
                                          : null,
                                      label: Text(e),
                                      side: selectedTopics.contains(e)
                                          ? null
                                          : const BorderSide(
                                              color: AppPallete.borderColor,
                                            ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                      controller: titleController,
                      hintText: "Blog Title",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                      controller: descriptionController,
                      hintText: "Blog Content",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

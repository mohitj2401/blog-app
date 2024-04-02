import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pic_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const AddBlogPage());
  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    File? file = await pickImage();
    if (file != null) {
      setState(() {
        image = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Blog"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.done)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(
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
              SizedBox(
                height: 10,
              ),
              BlogEditor(
                controller: titleController,
                hintText: "Blog Title",
              ),
              SizedBox(
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
  }
}

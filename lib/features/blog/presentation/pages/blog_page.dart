import 'package:blog_app/features/blog/presentation/pages/add_bloag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    nameTextEditingController.dispose();
    passwordTextEditingController.dispose();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, AddBlogPage.route());
              },
              icon: Icon(CupertinoIcons.add_circled)),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(15.0), child: Container()),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs(List<BlogModel> blogs);

  List<BlogModel> getLocalBlogs();
}

class BlogLocalDataSourceImp implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImp(this.box);

  @override
  List<BlogModel> getLocalBlogs() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromMap(box.get(i.toString())));
      }
    });
    return blogs;
  }

  @override
  void uploadLocalBlogs(List<BlogModel> blogs) {
    box.clear();
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}

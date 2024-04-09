// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:blog_app/features/blog/domain/entity/blog.dart';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/features/blog/domain/repository/blog_rapo.dart';
import 'package:fpdart/fpdart.dart';

class EditBlog implements UseCase<Blog, EditBlogParams> {
  final BlogRepository blogRepository;

  EditBlog(this.blogRepository);
  @override
  Future<Either<Failure, Blog>> call(EditBlogParams params) async {
    return await blogRepository.editBlog(
      id: params.id,
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class EditBlogParams {
  final String id;
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;
  EditBlogParams({
    required this.id,
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}

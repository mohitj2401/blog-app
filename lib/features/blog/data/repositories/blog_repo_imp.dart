import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_data_sources.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_rapo.dart';
import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImp implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImp(this.blogRemoteDataSource, this.blogLocalDataSource,
      this.connectionChecker);

  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No Interbet Connection"));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        userId: posterId,
        title: title,
        content: content,
        imageUrl: "",
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl =
          await blogRemoteDataSource.uploadBlogImage(image, blogModel);

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        return right(blogLocalDataSource.getLocalBlogs());
      }
      final blogs = await blogRemoteDataSource.getBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs);

      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> editBlog(
      {required String id,
      required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No Interbet Connection"));
      }
      BlogModel blogModel = BlogModel(
        id: id,
        userId: posterId,
        title: title,
        content: content,
        imageUrl: "",
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl =
          await blogRemoteDataSource.editBlogImage(image, blogModel);

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadBlog = await blogRemoteDataSource.editBlog(blogModel);

      return right(uploadBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blogModel);
  Future<BlogModel> editBlog(BlogModel blogModel);
  Future<List<BlogModel>> getBlogs();
  Future<String> uploadBlogImage(File file, BlogModel blogModel);
  Future<String> editBlogImage(File file, BlogModel blogModel);
}

class BlogRemoteDataSourceImp implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImp(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blogModel) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blogModel.toJson())
          .select();
      return BlogModel.fromMap(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(File file, BlogModel blogModel) async {
    try {
      await supabaseClient.storage
          .from('blog_images')
          .upload(blogModel.id, file);

      return supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(blogModel.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*,profiles (name)');

      return blogs
          .map((blog) => BlogModel.fromMap(blog)
              .copyWith(userName: blog['profiles']['name']))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> editBlog(BlogModel blogModel) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .update(blogModel.toJson())
          .eq('id', blogModel.id)
          .select();
      return BlogModel.fromMap(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> editBlogImage(File file, BlogModel blogModel) async {
    try {
      await supabaseClient.storage
          .from('blog_images')
          .update(blogModel.id, file);

      return supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(blogModel.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

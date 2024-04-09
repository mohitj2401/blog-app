import 'dart:io';

import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/edit_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final EditBlog _editBlog;
  final GetBlogs _getBlogs;
  final DeleteBlogCase _deleteBlog;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetBlogs getBlogs,
    required EditBlog editBlog,
    required DeleteBlogCase deleteBlog,
  })  : _getBlogs = getBlogs,
        _uploadBlog = uploadBlog,
        _editBlog = editBlog,
        _deleteBlog = deleteBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });

    on<BlogUpload>(_uploadBlogDb);
    on<GetAllBlog>(_getAllBlog);
    on<EditBlogBloc>(_editBlogDb);
    on<DeleteBlogEvent>(_deleteBlogDB);
  }
  _uploadBlogDb(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(UploadBlogParams(
      image: event.image,
      title: event.title,
      content: event.content,
      posterId: event.posterId,
      topics: event.topics,
    ));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogSuccess()),
    );
  }

  _editBlogDb(EditBlogBloc event, Emitter<BlogState> emit) async {
    final res = await _editBlog(EditBlogParams(
      id: event.id,
      image: event.image,
      title: event.title,
      content: event.content,
      posterId: event.posterId,
      topics: event.topics,
    ));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogEditSuccess()),
    );
  }

  _deleteBlogDB(DeleteBlogEvent event, Emitter<BlogState> emit) async {
    final res = await _deleteBlog(
        DeleteBlogCaseParams(id: event.id, imageUrl: event.imageUrl));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDeleteSuccess()),
    );
  }

  _getAllBlog(GetAllBlog event, Emitter<BlogState> emit) async {
    final res = await _getBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDisplaySuccess(r)),
    );
  }
}

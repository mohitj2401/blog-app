part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogSuccess extends BlogState {}

final class BlogEditSuccess extends BlogState {}

final class BlogDeleteSuccess extends BlogState {}

final class BlogFailure extends BlogState {
  final String message;

  BlogFailure(this.message);
}

final class BlogDisplaySuccess extends BlogState {
  final List<Blog> blogs;

  BlogDisplaySuccess(this.blogs);
}

final class UserLogOutSuccess extends BlogState {}

// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/features/blog/domain/repository/blog_rapo.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlogCase implements UseCase<bool, DeleteBlogCaseParams> {
  final BlogRepository blogRepository;

  DeleteBlogCase(this.blogRepository);

  @override
  Future<Either<Failure, bool>> call(DeleteBlogCaseParams params) async {
    return await blogRepository.deleteBlog(
        id: params.id, imageUrl: params.imageUrl);
  }
}

class DeleteBlogCaseParams {
  final String id;
  final String imageUrl;

  DeleteBlogCaseParams({
    required this.id,
    required this.imageUrl,
  });
}

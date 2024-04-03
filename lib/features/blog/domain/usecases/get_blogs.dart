// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:blog_app/features/blog/domain/entity/blog.dart';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/features/blog/domain/repository/blog_rapo.dart';
import 'package:fpdart/fpdart.dart';

class GetBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;

  GetBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getBlogs();
  }
}

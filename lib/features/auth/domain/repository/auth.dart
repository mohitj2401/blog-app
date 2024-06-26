import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/common/entity/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signupWithEmailAndPassword(
      {required String name, required String email, required String password});

  Future<Either<Failure, User>> signinWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<Failure, User>> currentUSer();

  Future<Either<Failure, bool>> signOut();
}

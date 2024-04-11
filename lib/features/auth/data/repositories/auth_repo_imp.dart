import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_data_sources.dart';
import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth.dart';
import 'package:fpdart/src/either.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthDataSource authDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImp(this.authDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> signinWithEmailAndPassword(
      {required String email, required String password}) async {
    return await _getUser(() async => await authDataSource
        .loginWithEmailAndPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signupWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    return await _getUser(() async => authDataSource.signupWithEmailAndPassword(
        name: name, email: email, password: password));
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if ((await connectionChecker.isConnected)) {
        final user = await fn();
        return right(user);
      } else {
        return left(Failure("Not internet Connection"));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUSer() async {
    try {
      if (!(await connectionChecker.isConnected)) {
        final seesion = authDataSource.currentSession;
        if (seesion == null) {
          return left(Failure("Login Expired"));
        } else {
          return right(UserModel(
              id: seesion.user.id, name: "", email: seesion.user.email!));
        }
      }
      final user = await authDataSource.getCurrentUser();
      if (user == null) {
        return left(Failure("Login Expired"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      if (!(await connectionChecker.isConnected)) {
        return left((Failure("Not internet Connection")));
      }
      final result = await authDataSource.logoutUser();
      // const result = true;
      if (result == null || !result) {
        return left(Failure("Login Expired"));
      }
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

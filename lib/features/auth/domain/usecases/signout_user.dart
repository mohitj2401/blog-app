import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth.dart';
import 'package:fpdart/fpdart.dart';

class SignOutUser implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  SignOutUser(this.authRepository);
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}

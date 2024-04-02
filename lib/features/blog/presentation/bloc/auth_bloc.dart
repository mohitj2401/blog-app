import 'package:blog_app/core/common/widgets/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signin.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_signupWithEmailPassword);
    on<AuthSignIn>(_signinWithEmailPassword);
    on<AuthLoggedIn>(_isUserLoggedIn);
  }

  _signupWithEmailPassword(event, emit) async {
    final res = await _userSignUp(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));
    res.fold(
      (l) => {emit(AuthFailure(message: l.message))},
      (r) => {_emitAuthSuccess(r, emit)},
    );
  }

  _signinWithEmailPassword(event, emit) async {
    final res = await _userSignIn(
        UserSignInParams(email: event.email, password: event.password));
    res.fold(
      (l) => {emit(AuthFailure(message: l.message))},
      (r) => {_emitAuthSuccess(r, emit)},
    );
  }

  _isUserLoggedIn(event, emit) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => {emit(AuthFailure(message: l.message))},
      (r) {
        print(r);
        return {_emitAuthSuccess(r, emit)};
      },
    );
  }

  _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}

import 'package:blog_app/features/auth/domain/entity/user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signin.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;

  AuthBloc({required UserSignUp userSignUp, required UserSignIn userSignIn})
      : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        super(AuthInitial()) {
    on<AuthSignUp>(_signupWithEmailPassword);
    on<AuthSignIn>(_signinWithEmailPassword);
  }

  _signupWithEmailPassword(event, emit) async {
    emit(AuthLoading());

    final res = await _userSignUp(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));
    res.fold(
      (l) => {emit(AuthFailure(message: l.message))},
      (r) => {emit(AuthSuccess(user: r))},
    );
  }

  _signinWithEmailPassword(event, emit) async {
    emit(AuthLoading());

    final res = await _userSignIn(
        UserSignInParams(email: event.email, password: event.password));
    res.fold(
      (l) => {emit(AuthFailure(message: l.message))},
      (r) => {emit(AuthSuccess(user: r))},
    );
  }
}

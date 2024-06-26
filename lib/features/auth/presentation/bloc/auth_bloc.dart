import 'package:blog_app/core/common/widgets/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/signout_user.dart';
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
  final SignOutUser _signOutUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required SignOutUser signOutUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _signOutUser = signOutUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_signupWithEmailPassword);
    on<AuthSignIn>(_signinWithEmailPassword);
    on<AuthLoggedIn>(_isUserLoggedIn);

    on<AuthSignOut>(_isUserLoggedOut);
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

  _isUserLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) {
        _appUserCubit.updateUser(null);
        emit(AuthFailure(message: l.message));
      },
      (r) {
        return {_emitAuthSuccess(r, emit)};
      },
    );
  }

  _isUserLoggedOut(AuthSignOut event, Emitter<AuthState> emit) async {
    final res = await _signOutUser(NoParams());

    res.fold(
      (l) {
        emit(AuthFailure(message: l.message));
      },
      (r) {
        _appUserCubit.signOut();
        emit(AuthSignOutSuccess());
      },
    );
  }

  _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}

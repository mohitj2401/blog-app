import 'package:blog_app/core/common/entity/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserLoggedOut());
    } else {
      emit(AppUserLoggedIn(user));
    }
  }

  void signOut() {
    emit(AppUserLoggedOut());
  }
}

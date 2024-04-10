import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthDataSource {
  Session? get currentSession;
  Future<UserModel> signupWithEmailAndPassword(
      {required String name, required String email, required String password});

  Future<UserModel> loginWithEmailAndPassword(
      {required String email, required String password});

  Future<UserModel?> getCurrentUser();

  Future<bool?> logoutUser();
}

class AuthDataSourceImp implements AuthDataSource {
  final SupabaseClient supabaseClient;

  AuthDataSourceImp(this.supabaseClient);

  @override
  Session? get currentSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      if (response.user == null) {
        throw ServerException("user is null!");
      }

      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(email: email, password: password, data: {
        'name': name,
      });
      if (response.user == null) {
        throw ServerException("user is null!");
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentSession!.user.id);
        return UserModel.fromJson(userData.first)
            .copyWith(email: currentSession!.user.email);
      }
      return null;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool?> logoutUser() async {
    try {
      if (currentSession != null) {
        await supabaseClient.auth.signOut();
        return true;
      }
      return null;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

import 'package:blog_app/features/auth/domain/entity/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.name, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        name: map['user_metadata']['name'],
        email: map['user_metadata']['email']);
  }
}

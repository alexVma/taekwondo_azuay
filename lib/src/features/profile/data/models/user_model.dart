import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String username,
    required String email,
    required String name,
  }) : super(
    id: id,
    username: username,
    email: email,
    name: name,
  );

  factory UserModel.fromFirebase(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
    );
  }
}

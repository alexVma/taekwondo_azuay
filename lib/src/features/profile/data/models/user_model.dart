import '../../domain/entities/user.dart';
import '../../domain/enums/user_role.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String username,
    required String email,
    required String name,
    required UserRole role,
  }) : super(
    id: id,
    username: username,
    email: email,
    name: name,
    role: role,
  );

  factory UserModel.fromFirebase(String id, Map<String, dynamic> data) {
    final roleString = data['role'] ?? 'ADMINISTRADOR';
    final role = UserRole.values.firstWhere(
      (e) => e.displayName == roleString,
      orElse: () => UserRole.administrador,
    );

    return UserModel(
      id: id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: role,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'role': role.displayName,
    };
  }
}

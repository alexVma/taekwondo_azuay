import '../enums/user_role.dart';

class UserEntity {
  final String id;
  final String username;
  final String email;
  final String name;
  final UserRole role;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.role,
  });
}

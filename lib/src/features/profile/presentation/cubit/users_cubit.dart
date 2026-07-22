import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository userRepository;

  UsersCubit({required this.userRepository}) : super(const UsersState.initial());

  Future<void> loadUsers() async {
    emit(const UsersState.loading());
    try {
      final users = await userRepository.getAllUsers();
      emit(UsersState.loaded(users));
    } catch (e) {
      emit(UsersState.error('Error al cargar usuarios: $e'));
    }
  }

  Future<void> createUser(UserModel user, String password) async {
    try {
      final success = await userRepository.createUser(user, password);
      if (success) {
        await loadUsers();
      } else {
        emit(const UsersState.error('Error al crear usuario'));
      }
    } catch (e) {
      emit(UsersState.error('Error: $e'));
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      final success = await userRepository.updateUser(user);
      if (success) {
        await loadUsers();
      } else {
        emit(const UsersState.error('Error al actualizar usuario'));
      }
    } catch (e) {
      emit(UsersState.error('Error: $e'));
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final success = await userRepository.deleteUser(userId);
      if (success) {
        await loadUsers();
      } else {
        emit(const UsersState.error('Error al eliminar usuario'));
      }
    } catch (e) {
      emit(UsersState.error('Error: $e'));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState.initial());

  Future<void> login(String username, String password) async {
    emit(const AuthState.loading());
    try {
      final user = await authRepository.loginUser(username, password);
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.error('Usuario o contraseña incorrectos'));
      }
    } catch (e) {
      emit(AuthState.error('Error: $e'));
    }
  }

  void logout() {
    emit(const AuthState.initial());
  }
}

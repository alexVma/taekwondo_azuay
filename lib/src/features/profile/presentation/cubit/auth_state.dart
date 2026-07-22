import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class AuthStateBase extends Equatable {
  const AuthStateBase();

  @override
  List<Object?> get props => [];
}

class AuthState extends AuthStateBase {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);

  const AuthState.loading() : this(status: AuthStatus.loading);

  const AuthState.authenticated(UserModel user)
      : this(status: AuthStatus.authenticated, user: user);

  const AuthState.error(String message)
      : this(status: AuthStatus.error, errorMessage: message);

  @override
  List<Object?> get props => [status, user, errorMessage];
}

enum AuthStatus { initial, loading, authenticated, error }

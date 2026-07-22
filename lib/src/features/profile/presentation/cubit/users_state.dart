import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class UsersStateBase extends Equatable {
  const UsersStateBase();

  @override
  List<Object?> get props => [];
}

class UsersState extends UsersStateBase {
  final UsersStatus status;
  final List<UserModel> users;
  final String? errorMessage;

  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  const UsersState.initial() : this(status: UsersStatus.initial);

  const UsersState.loading() : this(status: UsersStatus.loading);

  const UsersState.loaded(List<UserModel> users)
      : this(status: UsersStatus.loaded, users: users);

  const UsersState.error(String message)
      : this(status: UsersStatus.error, errorMessage: message);

  @override
  List<Object?> get props => [status, users, errorMessage];
}

enum UsersStatus { initial, loading, loaded, error }

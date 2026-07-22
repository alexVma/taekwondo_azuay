import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/profile_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.initial) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated && state.user != null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Perfil'),
              ),
              drawer: ProfileDrawer(user: state.user!),
              body: Center(
                child: Text('Bienvenido, ${state.user!.name}'),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

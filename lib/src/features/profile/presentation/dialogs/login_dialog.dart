import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Iniciar Sesión'),
      content: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pop(state.user);
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _usernameController,
                    enabled: state.status != AuthStatus.loading,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    enabled: state.status != AuthStatus.loading,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state.status == AuthStatus.loading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthCubit>().login(
                            _usernameController.text,
                            _passwordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              EliteMartialColors.secondaryContainer,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Ingresar'),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

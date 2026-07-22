import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../../data/models/user_model.dart';
import '../../domain/enums/user_role.dart';
import '../cubit/users_cubit.dart';

class UserFormDialog extends StatefulWidget {
  final UserModel? user;

  const UserFormDialog({
    super.key,
    this.user,
  });

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late UserRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _usernameController =
        TextEditingController(text: widget.user?.username ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _selectedRole = widget.user?.role ?? UserRole.administrativo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user == null ? 'Crear Usuario' : 'Editar Usuario'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: widget.user != null ? 'Dejar vacío para no cambiar' : '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              items: UserRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final newUser = UserModel(
              id: widget.user?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameController.text,
              username: _usernameController.text,
              email: _emailController.text,
              role: _selectedRole,
            );

            if (widget.user == null) {
              context.read<UsersCubit>().createUser(newUser, _passwordController.text);
            } else {
              context.read<UsersCubit>().updateUser(newUser);
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: EliteMartialColors.secondaryContainer,
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

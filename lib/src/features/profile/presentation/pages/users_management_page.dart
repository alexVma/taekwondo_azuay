import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';
import '../dialogs/user_form_dialog.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().loadUsers();
  }

  Widget _buildHeaderCell(String label) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: EliteMartialColors.onSecondaryContainer,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final cubit = context.read<UsersCubit>();
          showDialog(
            context: context,
            builder: (dialogContext) => BlocProvider.value(
              value: cubit,
              child: const UserFormDialog(),
            ),
          );
        },
        backgroundColor: EliteMartialColors.secondaryContainer,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state.status == UsersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == UsersStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Error'),
            );
          }

          if (state.users.isEmpty) {
            return const Center(
              child: Text('No hay usuarios'),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      color: EliteMartialColors.secondaryContainer,
                      width: constraints.maxWidth,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildHeaderCell('Nombre'),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildHeaderCell('Usuario'),
                          ),
                          Expanded(
                            flex: 3,
                            child: _buildHeaderCell('Email'),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildHeaderCell('Rol'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildHeaderCell('Acciones'),
                          ),
                        ],
                      ),
                    ),
                    ...state.users.asMap().entries.map((entry) {
                      final index = entry.key;
                      final user = entry.value;
                      final isEven = index.isEven;
                      return Container(
                        color: isEven
                            ? EliteMartialColors.surfaceContainerLowest
                            : EliteMartialColors.surfaceContainer,
                        width: constraints.maxWidth,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildCell(user.name),
                            ),
                            Expanded(
                              flex: 2,
                              child: _buildCell(user.username),
                            ),
                            Expanded(
                              flex: 3,
                              child: _buildCell(user.email),
                            ),
                            Expanded(
                              flex: 2,
                              child: _buildCell(user.role.displayName),
                            ),
                            Expanded(
                              flex: 1,
                              child: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text('Editar'),
                                    onTap: () {
                                      final cubit = context.read<UsersCubit>();
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) =>
                                            BlocProvider.value(
                                          value: cubit,
                                          child: UserFormDialog(
                                            user: user,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Eliminar'),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Confirmar eliminación'),
                                          content: Text(
                                              '¿Está seguro de que desea eliminar a ${user.name}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<UsersCubit>()
                                                    .deleteUser(user.id);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/features/academies/presentation/cubit/academies_management_cubit.dart';
import 'package:taekwondo_azuay/src/features/academies/presentation/pages/academies_management_page.dart';
import 'package:taekwondo_azuay/src/features/events/presentation/pages/events_list_page.dart';
import '../../data/models/user_model.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/users_cubit.dart';
import '../pages/users_management_page.dart';

class ProfileDrawer extends StatelessWidget {
  final UserModel user;

  const ProfileDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: EliteMartialColors.primary,
            ),
            accountName: Text(user.name),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: EliteMartialColors.secondary,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Gestión de Usuarios'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: GetIt.instance<UsersCubit>(),
                    child: const UsersManagementPage(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Gestión de Academias'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: GetIt.instance<AcademiesManagementCubit>(),
                    child: const AcademiesManagementPage(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Gestión de Eventos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventsListPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              context.read<AuthCubit>().logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

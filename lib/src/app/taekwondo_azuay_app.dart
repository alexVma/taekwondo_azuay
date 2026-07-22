import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_theme.dart';
import 'package:taekwondo_azuay/src/app/main_navigation_page.dart';
import 'package:taekwondo_azuay/src/features/profile/presentation/cubit/auth_cubit.dart';

class TaekwondoAzuayApp extends StatelessWidget {
  const TaekwondoAzuayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.instance<AuthCubit>(),
      child: MaterialApp(
        title: 'Azuay Taekwondo',
        debugShowCheckedModeBanner: false,
        theme: EliteMartialTheme.light(),
        home: const MainNavigationPage(),
      ),
    );
  }
}

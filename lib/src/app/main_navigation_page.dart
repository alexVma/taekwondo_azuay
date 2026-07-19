import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/features/academies/presentation/pages/academies_map_page.dart';
import 'package:taekwondo_azuay/src/features/home/domain/entities/home_action.dart';
import 'package:taekwondo_azuay/src/features/home/presentation/organisms/home_top_bar.dart';
import 'package:taekwondo_azuay/src/features/home/presentation/pages/home_page.dart';
import 'package:taekwondo_azuay/src/features/ranking/presentation/pages/ranking_page.dart';
import 'package:taekwondo_azuay/src/features/tournaments/presentation/pages/tournaments_page.dart';

import '../core/di/academy_injection.dart';
import '../features/academies/presentation/cubit/academies_cubit.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static final _pages = <Widget>[
    const HomePage(),
    const RankingPage(),
    const TournamentsPage(),
    BlocProvider(
      create: (_) => sl<AcademiesCubit>()..loadAcademies(),
      child: const AcademiesMapPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EliteMartialColors.surfaceContainerLowest,
      appBar: const TopBar(),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: EliteMartialColors.surfaceContainerLowest,
        selectedItemColor: EliteMartialColors.secondaryContainer,
        unselectedItemColor: EliteMartialColors.onSurfaceVariant,
        selectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        items: [
          for (final item in HomeNavItem.items)
            BottomNavigationBarItem(
              icon: Icon(item.icon),
              activeIcon: _ActiveNavIcon(icon: item.icon),
              label: item.label,
            ),
        ],
      ),
    );
  }
}

class _ActiveNavIcon extends StatelessWidget {
  const _ActiveNavIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 28,
      decoration: BoxDecoration(
        color: EliteMartialColors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: EliteMartialColors.onSecondary, size: 22),
    );
  }
}

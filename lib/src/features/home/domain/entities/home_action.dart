import 'package:flutter/material.dart';

class HomeAction {
  const HomeAction({
    required this.label,
    required this.icon,
    required this.isPrimary,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;

  static const actions = <HomeAction>[
    HomeAction(
        label: 'Ranking', icon: Icons.bar_chart_rounded, isPrimary: true),
    HomeAction(
        label: 'Torneos', icon: Icons.emoji_events_outlined, isPrimary: true),
    HomeAction(
        label: 'Academias', icon: Icons.location_on_outlined, isPrimary: false),
    HomeAction(
        label: 'Noticias', icon: Icons.newspaper_rounded, isPrimary: false),
  ];
}

class HomeNavItem {
  const HomeNavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;

  static const items = <HomeNavItem>[
    HomeNavItem(label: 'Inicio', icon: Icons.home_rounded),
    HomeNavItem(label: 'Ranking', icon: Icons.bar_chart_rounded),
    HomeNavItem(label: 'Torneos', icon: Icons.emoji_events_outlined),
    HomeNavItem(label: 'Academias', icon: Icons.location_on_outlined),
  ];
}

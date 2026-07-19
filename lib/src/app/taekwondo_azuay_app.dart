import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_theme.dart';
import 'package:taekwondo_azuay/src/app/main_navigation_page.dart';

class TaekwondoAzuayApp extends StatelessWidget {
  const TaekwondoAzuayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azuay Taekwondo',
      debugShowCheckedModeBanner: false,
      theme: EliteMartialTheme.light(),
      home: const MainNavigationPage(),
    );
  }
}

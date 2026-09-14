import 'package:flutter/material.dart';

import 'core/route/route.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Marketplace',
      theme: AppThemes.lightTheme,
      routerConfig: AppRoute.routes,
    );
  }
}

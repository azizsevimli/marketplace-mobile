import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/providers/category_provider.dart';
import 'core/route/route.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CategoryProvider())],
      child: const MyApp(),
    ),
  );
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

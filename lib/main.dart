import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/providers/admin_product_provider.dart';
import 'core/providers/admin_users_provider.dart';
import 'core/providers/category_provider.dart';
import 'core/route/route.dart';
import 'core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => AdminUsersProvider()),
        ChangeNotifierProvider(create: (_) => AdminProductProvider()),
      ],
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

import 'package:go_router/go_router.dart';

import '../../screens/home_screen.dart';

class AppRoute {
  static final GoRouter routes = GoRouter(
    initialLocation: '/home',
    routes: [GoRoute(path: '/home', builder: (context, state) => HomeScreen())],
  );
}

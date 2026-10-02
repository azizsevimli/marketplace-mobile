import 'package:go_router/go_router.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/admin_login_screen.dart';
import '../../screens/home_screen.dart';

class AppRoute {
  static final GoRouter routes = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
      GoRoute(
        path: '/admin/login',
        builder: (context, state) => AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => AdminDashboardScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    ],
  );
}

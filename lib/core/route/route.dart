import 'package:go_router/go_router.dart';

import '../../screens/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/admin_login_screen.dart';
import '../../screens/vendor/vendor_dashboard_screen.dart';
import '../../screens/vendor/vendor_login_screen.dart';
import '../../screens/vendor/vendor_register_screen.dart';
import '../../screens/home_screen.dart';

class AppRoute {
  static final GoRouter routes = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
      GoRoute(
        path: '/vendor/login',
        builder: (context, state) => VendorLoginScreen(),
      ),
      GoRoute(
        path: '/vendor/register',
        builder: (context, state) => VendorRegisterScreen(),
      ),
      GoRoute(
        path: '/vendor/dashboard',
        builder: (context, state) => VendorDashboardScreen(),
      ),
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

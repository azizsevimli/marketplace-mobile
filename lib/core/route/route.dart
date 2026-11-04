import 'package:go_router/go_router.dart';
import 'package:marketplace_mobile/screens/admin/product_detail_screen.dart';

import '../../screens/admin/admin_admins_screen.dart';
import '../../screens/admin/admin_categories_screen.dart';
import '../../screens/admin/admin_customers_screen.dart';
import '../../screens/admin/admin_orders_screen.dart';
import '../../screens/admin/admin_products_screen.dart';
import '../../screens/admin/admin_stores_screen.dart';
import '../../screens/admin/admin_vendors_screen.dart';
import '../../screens/admin/new_admin_screen.dart';
import '../../screens/admin/order_detail_screen.dart';
import '../../screens/admin/vendor_detail_screen.dart';
import '../../screens/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/admin_users_screen.dart';
import '../../screens/vendor/vendor_dashboard_screen.dart';
import '../../screens/home_screen.dart';

class AppRoute {
  static final GoRouter routes = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/vendor/dashboard',
        builder: (context, state) => const VendorDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: '/admin/users/admins',
        builder: (context, state) => const AdminAdminsScreen(),
      ),
      GoRoute(
        path: '/admin/users/customers',
        builder: (context, state) => const AdminCustomersScreen(),
      ),
      GoRoute(
        path: '/admin/users/vendors',
        builder: (context, state) => const AdminVendorsScreen(),
      ),
      GoRoute(
        path: '/admin/users/vendors/:id',
        builder: (context, state) {
          final String id = state.pathParameters['id']!;
          return VendorDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: '/admin/users/admins/new',
        builder: (context, state) => const NewAdminScreen(),
      ),
      GoRoute(
        path: '/admin/categories',
        builder: (context, state) => const AdminCategoriesScreen(),
      ),
      GoRoute(
        path: '/admin/stores',
        builder: (context, state) => const AdminStoresScreen(),
      ),
      GoRoute(
        path: '/admin/orders',
        builder: (context, state) => const AdminOrdersScreen(),
      ),
      GoRoute(
        path: '/admin/orders/:orderId',
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return OrderDetailScreen(order: data['order']);
        },
      ),
      GoRoute(
        path: '/admin/products',
        builder: (context, state) => const AdminProductsScreen(),
      ),
      GoRoute(
        path: '/admin/products/:id',
        builder: (context, state) {
          final String id = state.pathParameters['id']!;
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
  );
}

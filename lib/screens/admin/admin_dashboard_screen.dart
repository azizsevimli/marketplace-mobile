import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/result.dart';
import '../../models/admin_stats_model.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/admin/dashboard_card.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/loading_screen.dart';
import '../../widgets/admin/menu_drawer.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  AdminStatsModel? _stats;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isLogout = false;

  Future<void> _getStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final Result<AdminStatsModel> result =
        await AdminService.getDashboardStats();

    switch (result) {
      case Ok<AdminStatsModel>():
        setState(() {
          _stats = result.value;
          _isLoading = false;
        });
      case Error<AdminStatsModel>():
        setState(() {
          _errorMessage = result.error.toString();
          _isLoading = false;
        });
    }
  }

  Future<void> _logout() async {
    setState(() => _isLogout = true);

    final Result<bool> result = await AuthService.logout();

    if (!mounted) return;

    switch (result) {
      case Ok<bool>():
        context.go('/');
        setState(() => _isLogout = false);
      case Error<bool>():
        setState(() => _isLogout = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.error.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    _getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace Admin'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isLogout
                ? const CircularProgressIndicator()
                : const Icon(Icons.logout_outlined),
            onPressed: _isLogout ? null : _logout,
          ),
        ],
      ),
      drawer: AdminMenuDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingScreen();
    }

    if (_errorMessage != null) {
      return ErrorScreen(errorMessage: _errorMessage!, onPressed: _getStats);
    }

    if (_stats == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('İstatistik bulunamadı.'),
            ElevatedButton(
              onPressed: _getStats,
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            DashboardCard(
              title: 'Kullanıcı',
              titleValue: _stats!.users.total,
              subtitles: [
                (subtitle: 'Admin', value: _stats!.users.admin),
                (subtitle: 'Müşteri', value: _stats!.users.customer),
                (subtitle: 'Vendor', value: _stats!.users.vendor),
              ],
              icon: Icons.person_outline,
              buttonTitle: 'Kullanıcılar',
              route: '/admin/users',
            ),
            DashboardCard(
              title: 'Ürün',
              titleValue: _stats!.products.total,
              subtitles: [
                (subtitle: 'Bekliyor', value: _stats!.products.pending),
                (subtitle: 'Onaylandı', value: _stats!.products.active),
                (subtitle: 'Reddedildi', value: _stats!.products.rejected),
                (subtitle: 'Pasif', value: _stats!.products.passive),
              ],
              icon: Icons.shopping_cart_outlined,
              buttonTitle: 'Ürünler',
              route: '/admin/products',
            ),
            DashboardCard(
              title: 'Sipariş',
              titleValue: _stats!.orders.total,
              subtitles: [
                (subtitle: 'Bekliyor', value: _stats!.orders.pending),
                (subtitle: 'Hazırlanıyor', value: _stats!.orders.preparing),
                (subtitle: 'Teslim edildi', value: _stats!.orders.completed),
                (subtitle: 'İptal', value: _stats!.orders.cancelled),
              ],
              icon: Icons.receipt_long_outlined,
              buttonTitle: 'Siparişler',
              route: '/admin/orders',
            ),
          ],
        ),
      ),
    );
  }
}

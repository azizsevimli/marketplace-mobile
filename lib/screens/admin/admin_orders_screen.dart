import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketplace_mobile/widgets/admin/error_screen.dart';

import '../../core/utils/result.dart';
import '../../models/order_model.dart';
import '../../services/admin_service.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/loading_screen.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  late List<OrderModel> orders;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      orders = [];
    });

    final Result<List<OrderModel>> result = await AdminService.getOrders();

    switch (result) {
      case Ok<List<OrderModel>>():
        setState(() {
          orders = result.value;
          _isLoading = false;
        });
      case Error<List<OrderModel>>():
        setState(() {
          _errorMessage = result.error.toString();
          _isLoading = false;
        });
    }
  }

  @override
  void initState() {
    _fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: 'Siparişler'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingScreen();
    }

    if (_errorMessage != null) {
      return ErrorScreen(errorMessage: _errorMessage!, onPressed: _fetchOrders);
    }

    if (orders.isEmpty) {
      return const Center(child: Text('Henüz sipariş bulunmuyor.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final OrderModel order = orders[index];
        return Card(
          child: ListTile(
            title: Text(order.id),
            subtitle: Text('Sipariş Sahibi: ${order.customerFullName}'),
            onTap: () => context.push(
              '/admin/orders/${order.id}',
              extra: {'order': order},
            ),
          ),
        );
      },
    );
  }
}

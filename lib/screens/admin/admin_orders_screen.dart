import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/order_model.dart';
import '../../services/admin_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  late List<OrderModel> orders;
  String? errorMessage;
  bool isLoading = false;

  Future<void> fetchOrders() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        orders = [];
      });

      final Map<String, dynamic> data = await AdminService.getOrders();

      if (data['orders'] != null) {
        setState(() {
          orders = data['orders'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = data['message'];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Siparişler')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hata: $errorMessage'),
            ElevatedButton(
              onPressed: fetchOrders,
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
      );
    }

    if (orders.isEmpty) {
      return const Center(child: Text('Henüz sipariş bulunmuyor.'));
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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

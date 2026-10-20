import 'package:flutter/material.dart';

import '../../models/order_item_model.dart';
import '../../models/order_model.dart';
import '../../services/admin_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel get order => widget.order;

  late List<OrderItemModel> orderItems;
  Map<String, List<OrderItemModel>> groupedItems = {};
  String? errorMessage;
  bool isLoading = false;

  Future<void> fetchOrderItems() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        orderItems = [];
      });

      Map<String, dynamic> data = await AdminService.getOrderItemsByOrderId(
        order.id,
      );

      if (data['orderItems'] != null) {
        setState(() {
          orderItems = data['orderItems'];
        });

        await groupOrderItems(orderItems);

        setState(() {
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

  Future<void> groupOrderItems(List<OrderItemModel> list) async {
    if (list.isNotEmpty) {
      for (final item in list) {
        groupedItems.putIfAbsent(item.storeId, () => []).add(item);
      }
    }
  }

  @override
  void initState() {
    fetchOrderItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final entries = groupedItems.entries.toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(order.id),
        titleTextStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      body: _buildBody(entries),
    );
  }

  Widget _buildBody(List<MapEntry<String, List<OrderItemModel>>> entries) {
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
              onPressed: fetchOrderItems,
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        spacing: 16.0,
        children: [_buildOrderDetailCard(), _buildStoreOrders(entries)],
      ),
    );
  }

  Card _buildOrderDetailCard() {
    return Card(
      color: Colors.blue.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'SİPARİŞ BİLGİLERİ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            Text('Sipariş Tarihi: ${order.createdAt}'),
            Text('Toplam Ücret: ${order.totalPrice}'),
            Text('Durumu: ${order.status}'),
            const SizedBox(height: 16.0),
            const Text(
              'MÜŞTERİ BİLGİLERİ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            Text('ID: ${order.customerId}'),
            Text('Ad-Soyad: ${order.customerFullName}'),
          ],
        ),
      ),
    );
  }

  Expanded _buildStoreOrders(
    List<MapEntry<String, List<OrderItemModel>>> entries,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final storeId = entries[index].key;
          final items = entries[index].value;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SİPARİŞ #${(index + 1).toString()}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Mağaza Bilgileri',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('ID: $storeId'),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Ürünler',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...[
                    for (final item in items)
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                        ),
                        title: Text(item.productTitle),
                        subtitle: Text(
                          'Adet: ${item.quantity}    Birim Ücret: ${item.unitPrice} TL',
                        ),
                        trailing: Text('${item.totalPrice} TL'),
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

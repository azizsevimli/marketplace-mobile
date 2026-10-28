import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';

class OrderInfoCard extends StatelessWidget {
  final OrderModel order;
  const OrderInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final createdAt = DateFormat(
      'dd MMMM yyyy - HH.mm (UTC)',
      'tr_TR',
    ).format(order.createdAt);

    return Card(
      color: Colors.blue.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 2.0,
          children: [
            _buildHeader('Sipariş Bilgileri'),
            Text('Sipariş Tarihi: $createdAt'),
            Text('Toplam Ücret: ${order.totalPrice} ₺'),
            Text('Durum: ${order.status.label}'),
            const SizedBox(height: 8.0),
            _buildHeader('Müşteri Bilgileri'),
            Text('ID: ${order.customerId}'),
            Text('İsim-Soyisim: ${order.customerFullName}'),
          ],
        ),
      ),
    );
  }

  Text _buildHeader(String header) {
    return Text(
      header,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

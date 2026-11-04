import 'package:flutter/material.dart';

import '../../models/order_item_model.dart';

class OrderPartCard extends StatelessWidget {
  final int index;
  final String storeId;
  final List<OrderItemModel> items;
  const OrderPartCard({
    super.key,
    required this.index,
    required this.storeId,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('SİPARİŞ #${index + 1}', 16.0),
            Text('ID: ${items[0].id}'),
            const SizedBox(height: 8.0),
            _buildHeader('Mağaza Bilgileri', 14.0),
            Text('ID: $storeId'),
            const SizedBox(height: 8.0),
            _buildHeader('Ürünler', 14.0),
            for (final item in items)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                title: Text(item.productTitle),
                subtitle: Text(
                  'Adet: ${item.quantity}    Birim Ücret: ${item.unitPrice} TL',
                ),
                trailing: Text('${item.totalPrice} ₺'),
              ),
          ],
        ),
      ),
    );
  }

  Text _buildHeader(String header, double size) {
    return Text(
      header,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

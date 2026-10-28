import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/store_model.dart';

class StoreExpansionTile extends StatelessWidget {
  final StoreModel store;
  const StoreExpansionTile({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final createdAt = DateFormat(
      'dd MMMM yyyy - HH.mm (UTC)',
      'tr_TR',
    ).format(store.createdAt);

    final updatedAt = DateFormat(
      'dd MMMM yyyy - HH.mm (UTC)',
      'tr_TR',
    ).format(store.updatedAt);

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      childrenPadding: const EdgeInsets.all(8.0),
      leading: _buildLeading(store.status),
      title: Text(store.name),
      subtitle: Text('Satıcı: ${store.vendorFullName}'),
      children: [
        _buildChildRow('ID', store.id),
        const SizedBox(height: 8.0),
        _buildChildRow('Açıklama', store.description),
        const SizedBox(height: 8.0),
        _buildChildRow('E-posta', store.email),
        const SizedBox(height: 8.0),
        _buildChildRow('Telefon', store.phone),
        const SizedBox(height: 8.0),
        _buildChildRow('Adres', store.address),
        const SizedBox(height: 8.0),
        _buildChildRow('Kayıt T.', createdAt),
        const SizedBox(height: 8.0),
        _buildChildRow('Düzenleme T.', updatedAt),
      ],
    );
  }

  Icon _buildLeading(String status) {
    switch (status) {
      case 'ACTIVE':
        return const Icon(Icons.check_box, color: Colors.green);
      case 'PASSIVE':
        return const Icon(Icons.indeterminate_check_box, color: Colors.amber);
      case 'DELETED':
        return const Icon(Icons.delete_rounded, color: Colors.redAccent);
      default:
        return const Icon(Icons.question_mark_rounded, color: Colors.grey);
    }
  }

  Row _buildChildRow(String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(flex: 5, child: Text(content, textAlign: TextAlign.justify)),
      ],
    );
  }
}

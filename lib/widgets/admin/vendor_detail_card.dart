import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/vendor_model.dart';

class VendorDetailCard extends StatelessWidget {
  final VendorModel vendor;
  const VendorDetailCard({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    final createdAt = DateFormat(
      'dd MMMM yyyy - HH.mm (UTC)',
      'tr_TR',
    ).format(vendor.createdAt);

    final updatedAt = DateFormat(
      'dd MMMM yyyy - HH.mm (UTC)',
      'tr_TR',
    ).format(vendor.updatedAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            _buildRow('ID', vendor.id),
            _buildRow('İsim', vendor.firstName),
            _buildRow('Soyisim', vendor.lastName),
            _buildRow('E-posta', vendor.email),
            _buildRow('Telefon', vendor.phone ?? 'Kayıtlı değil'),
            _buildRow('Kayıt Tarihi', createdAt),
            _buildRow('Güncelleme T.', updatedAt),
          ],
        ),
      ),
    );
  }

  Row _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text(': ', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Flexible(flex: 5, child: Text(value)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/product_model.dart';

class ProductDetailCard extends StatelessWidget {
  final ProductModel product;
  const ProductDetailCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      'dd MMMM yyyy - HH.mm (UTC)',
      'tr_TR',
    ).format(product.createdAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            _buildHeader('Ürün Bilgileri'),
            _buildChildRow('ID', product.id),
            _buildChildRow('Başlık', product.title),
            _buildChildRow('Açıklama', product.description),
            _buildChildRow('Kategori', product.categoryId ?? 'Kategori yok'),
            _buildChildRow(
              'Alt kategori',
              product.subcategoryId ?? 'Kategori yok',
            ),
            _buildChildRow('Mağaza ID', product.storeId),
            _buildChildRow('Stok', product.stockQuantity.toString()),
            _buildChildRow('Kayıt Tarihi', date),
            _buildChildRow('Durum', product.status.label),
            _buildHeader('Fiyat Bilgileri'),
            _buildChildRow('Ücret', product.price.toString()),
            _buildChildRow('İndirim', product.discountPrice.toString()),
          ],
        ),
      ),
    );
  }

  Text _buildHeader(String header) {
    return Text(
      header,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
    );
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

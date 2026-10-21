import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String get productId => widget.productId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productId),
        titleTextStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(children: [Text(productId)]);
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/providers/admin_product_provider.dart';
import '../../models/product_status.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  ProductStatus selectedStatus = ProductStatus.pending;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProductProvider>().fetchProducts(selectedStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürünler')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        spacing: 16.0,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildSegmentedButton(),
          ),
          Expanded(
            child: Consumer<AdminProductProvider>(
              builder: (context, provider, child) => _buildBodyList(provider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyList(AdminProductProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hata: ${provider.errorMessage}'),
            ElevatedButton(
              onPressed: () => provider.fetchProducts(selectedStatus),
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
      );
    }

    if (provider.products.isEmpty) {
      return const Center(child: Text('Ürün bulunmuyor.'));
    }

    return ListView.builder(
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        final product = provider.products[index];
        final date = DateFormat(
          'dd MMMM yyyy - HH.mm (UTC)',
          'tr_TR',
        ).format(product.createdAt);
        return ListTile(
          title: Text(product.title),
          subtitle: Text('Kayıt Tarihi: $date'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => context.push(
            '/admin/products/${product.id}',
          ), // Detay sayfasına yönlendirme yapılacak.
        );
      },
    );
  }

  Widget _buildSegmentedButton() {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: [
        for (final status in ProductStatus.values)
          ButtonSegment(value: status, label: Text(status.label)),
      ],
      selected: <ProductStatus>{selectedStatus},
      onSelectionChanged: (Set<ProductStatus> newSelection) {
        setState(() {
          selectedStatus = newSelection.first;
        });
        context.read<AdminProductProvider>().fetchProducts(selectedStatus);
      },
    );
  }
}

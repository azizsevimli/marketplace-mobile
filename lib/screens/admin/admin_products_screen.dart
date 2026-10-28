import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/providers/admin_product_provider.dart';
import '../../models/product_status.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/loading_screen.dart';
import '../../widgets/admin/products_segmented_button.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  ProductStatus selectedStatus = ProductStatus.pending;

  Future<void> _openDetail(String id) async {
    await context.push('/admin/products/$id');
    if (!mounted) return;
    context.read<AdminProductProvider>().fetchProducts(selectedStatus);
  }

  void handleSelectionChanged(Set<ProductStatus> newSelection) {
    setState(() {
      selectedStatus = newSelection.first;
    });
    context.read<AdminProductProvider>().fetchProducts(selectedStatus);
  }

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
      appBar: adminScreensAppBar(context: context, title: 'Ürünler'),
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
            child: ProductsSegmentedButton(
              selectedStatus: selectedStatus,
              onSelectionChanged: handleSelectionChanged,
            ),
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
      return const LoadingScreen();
    }

    if (provider.errorMessage != null) {
      return ErrorScreen(
        errorMessage: provider.errorMessage!,
        onPressed: () => provider.fetchProducts(selectedStatus),
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
          onTap: () => _openDetail(product.id),
        );
      },
    );
  }
}

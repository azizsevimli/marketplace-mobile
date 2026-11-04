import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/providers/admin_product_provider.dart';
import '../../models/product_model.dart';
import '../../models/product_status.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/loading_screen.dart';
import '../../widgets/admin/product_detail_card.dart';
import '../../widgets/admin/status_dropdown.dart';
import '../../widgets/product_image_area.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String get productId => widget.productId;

  Future<void> handleUpdateStatus(
    AdminProductProvider provider,
    String id,
  ) async {
    final status = provider.selectedStatus;

    if (status != null) {
      final result = await provider.updateProductStatus(id, status);

      if (!mounted) return;
      if (result) {
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.updateErrorMessage ?? 'Güncelleme başarısız',
            ),
          ),
        );
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProductProvider>().fetchProductDetail(productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminScreensAppBar(
        context: context,
        title: productId,
        size: 16.0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<AdminProductProvider>(
      builder: (context, provider, child) {
        final product = provider.product;

        if (provider.isLoading) {
          return const LoadingScreen();
        }

        if (product != null) {
          return _buildBodyColumn(provider, product);
        } else {
          return const Column(children: [Text('Ürün bulunamadı')]);
        }
      },
    );
  }

  Widget _buildBodyColumn(AdminProductProvider provider, ProductModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        spacing: 8.0,
        children: [
          ProductImageArea(imageList: product.productImages),
          ProductDetailCard(product: product),
          StatusDropdown(
            onSelected: (value) => provider.selectStatus(value),
            selectedStatus: provider.selectedStatus,
            statusList: ProductStatus.entries,
          ),
          ElevatedButton(
            onPressed: () => provider.isUpdating
                ? null
                : handleUpdateStatus(provider, product.id),
            child: provider.isUpdating
                ? const CircularProgressIndicator()
                : const Text('Durumu Kaydet'),
          ),
        ],
      ),
    );
  }
}

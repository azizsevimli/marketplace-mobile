import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/providers/admin_product_provider.dart';
import '../../models/product_model.dart';
import '../../models/product_status.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String get productId => widget.productId;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProductProvider>().fetchProductDetail(productId);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

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
    return Consumer<AdminProductProvider>(
      builder: (context, provider, child) {
        final product = provider.product;

        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (product != null) {
          return _buildBodyColumn(product, provider);
        } else {
          return Column(children: [Text('Ürün bulunamadı')]);
        }
      },
    );
  }

  Widget _buildBodyColumn(ProductModel product, AdminProductProvider provider) {
    final date = DateFormat(
      'dd MMMM yyyy - HH.mm (UTC)',
      'tr_TR',
    ).format(product.createdAt);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        spacing: 8.0,
        children: [
          _buildImageArea(product.productImages),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Text(
                    'Ürün Bilgileri',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  _buildChildRow('ID', product.id),
                  _buildChildRow('Başlık', product.title),
                  _buildChildRow('Açıklama', product.description),
                  _buildChildRow(
                    'Kategori',
                    product.categoryId ?? 'Kategori yok',
                  ), // TODO: ID yerine kategori isimleri gelecek
                  _buildChildRow(
                    'Alt kategori',
                    product.subcategoryId ?? 'Kategori yok',
                  ),
                  _buildChildRow('Mağaza ID', product.storeId),
                  _buildChildRow('Stok', product.stockQuantity.toString()),
                  _buildChildRow('Kayıt Tarihi', date),
                  _buildChildRow('Durum', product.status.label),
                  Text(
                    'Fiyat Bilgileri',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  _buildChildRow('Ücret', product.price.toString()),
                  _buildChildRow('İndirim', product.discountPrice.toString()),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Durum',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownMenu<ProductStatus>(
                initialSelection: provider.selectedStatus,
                onSelected: (value) => provider.selectStatus(value),
                dropdownMenuEntries: [
                  for (final status in ProductStatus.values)
                    DropdownMenuEntry(value: status, label: status.label),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: provider.isUpdating
                ? null
                : () async {
                    final status = provider.selectedStatus;
                    if (status == null) return;

                    final ok = await provider.updateProductStatus(
                      product.id,
                      status,
                    );

                    if (!mounted) return;

                    if (ok) {
                      context.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            provider.updateErrorMessage ??
                                'Güncelleme başarısız',
                          ),
                        ),
                      );
                    }
                  },
            child: provider.isUpdating
                ? CircularProgressIndicator()
                : Text('Durumu Kaydet'),
          ),
        ],
      ),
    );
  }

  SizedBox _buildImageArea(List<ProductImageModel> imageList) {
    final size = MediaQuery.of(context).size;
    if (imageList.isEmpty) {
      return SizedBox(
        width: size.width,
        height: size.height * 0.25,
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined, size: 48.0),
        ),
      );
    }
    return SizedBox(
      width: size.width,
      height: size.height * 0.25,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imageList.length,
            itemBuilder: (context, index) {
              final image = imageList[index];
              return Image.network(
                image.imageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 8.0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: imageList.length,
                effect: SwapEffect(dotWidth: 8.0, dotHeight: 8.0),
              ),
            ),
          ),
        ],
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

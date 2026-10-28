import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/product_model.dart';

class ProductImageArea extends StatelessWidget {
  final List<ProductImageModel> imageList;

  ProductImageArea({super.key, required this.imageList});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
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
      child: Stack(children: [_buildPageView(), _buildPageIndicator()]),
    );
  }

  PageView _buildPageView() {
    return PageView.builder(
      controller: _controller,
      itemCount: imageList.length,
      itemBuilder: (contexti, index) {
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
    );
  }

  Positioned _buildPageIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 8.0,
      child: Center(
        child: SmoothPageIndicator(
          controller: _controller,
          count: imageList.length,
          effect: const SwapEffect(dotWidth: 8.0, dotHeight: 8.0),
        ),
      ),
    );
  }
}

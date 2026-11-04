import 'package:flutter/material.dart';

import '../../models/product_status.dart';

class ProductsSegmentedButton extends StatelessWidget {
  final ProductStatus selectedStatus;
  final ValueChanged<Set<ProductStatus>> onSelectionChanged;

  const ProductsSegmentedButton({
    super.key,
    required this.selectedStatus,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: [
        for (final status in ProductStatus.values)
          ButtonSegment(value: status, label: Text(status.label)),
      ],
      selected: <ProductStatus>{selectedStatus},
      onSelectionChanged: onSelectionChanged,
    );
  }
}

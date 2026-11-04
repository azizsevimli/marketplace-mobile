import 'dart:collection';

import 'package:flutter/material.dart';

typedef VendorStatusEntry = DropdownMenuEntry<VendorStatus>;

enum VendorStatus {
  pending('PENDING', 'Bekliyor'),
  approved('APPROVED', 'Onaylandı'),
  rejected('REJECTED', 'Reddedildi');

  const VendorStatus(this.value, this.label);
  final String value;
  final String label;

  static VendorStatus fromApi(String apiValue) {
    for (final status in values) {
      if (status.value == apiValue) return status;
    }
    throw FormatException('Bilinmeyen ürün durumu: $apiValue');
  }

  static final List<VendorStatusEntry> entries =
      UnmodifiableListView<VendorStatusEntry>(
        values.map<VendorStatusEntry>(
          (VendorStatus status) =>
              VendorStatusEntry(value: status, label: status.label),
        ),
      );
}

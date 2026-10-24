enum ProductStatus {
  pending('PENDING', 'Bekliyor'),
  approved('APPROVED', 'Onaylandı'),
  rejected('REJECTED', 'Reddedildi'),
  passive('PASSIVE', 'Pasif');

  const ProductStatus(this.value, this.label);
  final String value;
  final String label;

  static ProductStatus fromApi(String apiValue) {
    for (final status in values) {
      if (status.value == apiValue) return status;
    }
    throw FormatException('Bilinmeyen ürün durumu: $apiValue');
  }
}

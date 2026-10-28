enum OrderItemStatus {
  pending('PENDING', 'Bekliyor'),
  confirmed('CONFIRMED', 'Onaylandı'),
  preparing('PREPARING', 'Hazırlanıyor'),
  shipped('SHIPPED', 'Kargolandı'),
  completed('DELIVERED', 'Teslim Edildi'),
  cancelled('CANCELLED', 'İptal Edildi');

  const OrderItemStatus(this.value, this.label);
  final String value;
  final String label;

  static OrderItemStatus fromApi(String apiValue) {
    for (final status in values) {
      if (status.value == apiValue) return status;
    }
    throw FormatException('Bilinmeyen ürün durumu: $apiValue');
  }
}

enum OrderStatus {
  pending('PENDING', 'Bekliyor'),
  paid('PAID', 'Ödendi'),
  preparing('PREPARING', 'Hazırlanıyor'),
  completed('COMPLETED', 'Tamamlandı'),
  cancelled('CANCELLED', 'İptal Edildi');

  const OrderStatus(this.value, this.label);
  final String value;
  final String label;

  static OrderStatus fromApi(String apiValue) {
    for (final status in values) {
      if (status.value == apiValue) return status;
    }
    throw FormatException('Bilinmeyen ürün durumu: $apiValue');
  }
}

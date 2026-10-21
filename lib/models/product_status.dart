enum ProductStatus {
  pending('PENDING', 'Bekleyen'),
  approved('APPROVED', 'Onaylanan'),
  rejected('REJECTED', 'Reddedilen'),
  passive('PASSIVE', 'Pasif');

  const ProductStatus(this.value, this.label);
  final String value;
  final String label;
}

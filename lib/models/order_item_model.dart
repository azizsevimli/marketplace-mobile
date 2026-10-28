import 'order_item_status.dart';

class OrderItemModel {
  final String id;
  final String orderId;
  final String storeId;
  final String productId;
  final String productTitle;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final OrderItemStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.storeId,
    required this.productId,
    required this.productTitle,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      storeId: json['store_id'],
      productId: json['product_id'],
      productTitle: json['product_title'],
      quantity: json['quantity'],
      unitPrice: double.parse(json['unit_price']),
      totalPrice: double.parse(json['total_price']),
      status: OrderItemStatus.fromApi(json['status']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'storeId': storeId,
      'productId': productId,
      'productTitle': productTitle,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

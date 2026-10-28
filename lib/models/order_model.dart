import 'order_status.dart';

class OrderModel {
  final String id;
  final String customerId;
  final String customerFullName;
  final String shippingAddress;
  final double totalPrice;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.customerFullName,
    required this.shippingAddress,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      customerId: json['customer_id'],
      customerFullName: json['customer_full_name'],
      shippingAddress: json['shipping_address'],
      totalPrice: double.parse(json['total_price']),
      status: OrderStatus.fromApi(json['status']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerFullName': customerFullName,
      'shippingAddress': shippingAddress,
      'totalPrice': totalPrice,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

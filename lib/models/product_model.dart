class ProductModel {
  final String id;
  final String storeId;
  String? categoryId;
  String? subcategoryId;
  final String title;
  final String description;
  final double price;
  final double discountPrice;
  final int stockQuantity;
  final String sku;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductImageModel> productImages;

  ProductModel({
    required this.id,
    required this.storeId,
    this.categoryId,
    this.subcategoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.stockQuantity,
    required this.sku,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.productImages,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      storeId: json['store_id'],
      categoryId: json['category_id'],
      subcategoryId: json['subcategory_id'],
      title: json['title'],
      description: json['description'],
      price: double.parse(json['price']),
      discountPrice: double.parse(json['discount_price']),
      stockQuantity: json['stock_quantity'],
      sku: json['sku'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      productImages: (json['product_images'] as List<dynamic>)
          .map(
            (image) =>
                ProductImageModel.fromJson(image as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "store_id": storeId,
      "category_id": categoryId,
      "subcategory_id": subcategoryId,
      "title": title,
      "description": description,
      "price": price,
      "discount_price": discountPrice,
      "stock_quantity": stockQuantity,
      "sku": sku,
      "status": status,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      'productImages': productImages.map((image) => image.toJson()).toList(),
    };
  }
}

class ProductImageModel {
  final int id;
  String? productId;
  final String imageUrl;
  final int sortOrder;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductImageModel({
    required this.id,
    this.productId,
    required this.imageUrl,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'],
      productId: json['product_id'],
      imageUrl: json['imageUrl'],
      sortOrder: json['sortOrder'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'imageUrl': imageUrl,
      'sortOrder': sortOrder,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

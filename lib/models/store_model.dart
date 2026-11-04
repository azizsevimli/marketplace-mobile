class StoreModel {
  final String id;
  final String vendorId;
  final String vendorFullName;
  final String name;
  final String slug;
  final String description;
  final String? logoUrl;
  final String phone;
  final String email;
  final String address;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StoreModel({
    required this.id,
    required this.vendorId,
    required this.vendorFullName,
    required this.name,
    required this.slug,
    required this.description,
    this.logoUrl,
    required this.phone,
    required this.email,
    required this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      vendorId: json['vendor_id'],
      vendorFullName: json['vendor_full_name'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      logoUrl: json['logo'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'vendorFullName': vendorFullName,
      'name': name,
      'slug': slug,
      'description': description,
      'logoUrl': logoUrl,
      'phone': phone,
      'email': email,
      'address': address,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

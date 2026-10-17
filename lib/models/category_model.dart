class CategoryModel {
  final String id;
  final String title;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubcategoryModel> subcategories;

  CategoryModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.subcategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      subcategories: (json['subcategories'] as List<dynamic>)
          .map((item) => SubcategoryModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'subcategories': subcategories
          .map((subcategory) => subcategory.toJson())
          .toList(),
    };
  }
}

class SubcategoryModel {
  final String id;
  final String parentId;
  final String title;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubcategoryModel({
    required this.id,
    required this.parentId,
    required this.title,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'],
      parentId: json['parentId'],
      title: json['title'],
      slug: json['slug'],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'title': title,
      'slug': slug,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

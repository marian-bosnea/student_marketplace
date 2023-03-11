import '../../domain/entities/product_category_entity.dart';

class ProductCategoryModel extends ProductCategoryEntity {
  const ProductCategoryModel({required super.id, required super.name});

  static ProductCategoryModel? fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') || !json.containsKey('name')) return null;

    return ProductCategoryModel(
        id: json['id'] as int, name: json['name'] as String);
  }
}

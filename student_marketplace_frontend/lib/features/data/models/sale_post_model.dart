import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';

class SalePostModel extends SalePostEntity {
  SalePostModel(
      {required super.title,
      required super.description,
      required super.ownerId,
      required super.postingDate,
      required super.categoryId,
      required super.price,
      required super.images,
      super.postId,
      super.ownerName,
      super.categoryName});

  factory SalePostModel.fromJson(Map<String, dynamic> json) {
    return SalePostModel(
      title: json['title'],
      description: json['description'],
      ownerId: json['owner_id'].toString(),
      postingDate: json['date'],
      price: json['price'].toString(),
      categoryId: json['category_id'].toString(),
      images: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ownerName': ownerId,
      'postingDate': postingDate,
      'images': ''
    };
  }
}

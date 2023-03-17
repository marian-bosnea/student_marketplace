import '../../domain/entities/sale_post_entity.dart';

class SalePostModel extends SalePostEntity {
  SalePostModel(
      {required super.price,
      required super.title,
      required super.images,
      super.postId,
      super.ownerId,
      super.categoryId,
      super.description,
      super.postingDate,
      super.ownerName,
      super.categoryName,
      super.viewsCount,
      super.isFavorite,
      super.isOwn});

  factory SalePostModel.fromJson(Map<String, dynamic> json) {
    return SalePostModel(
      price: json['price'].toString(),
      title: json['title'],
      description: json['description'],
      ownerId: json['owner_id'],
      postingDate: json['date'],
      categoryId: json['category_id'],
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

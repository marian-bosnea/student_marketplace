import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';

class SalePostModel extends SalePostEntity {
  SalePostModel(
      {required super.title,
      required super.description,
      required super.ownerName,
      required super.postingDate,
      required super.images});

  factory SalePostModel.fromJson(Map<String, dynamic> json) {
    return SalePostModel(
      title: json['title'],
      description: json['description'],
      ownerName: json['owner_name'],
      postingDate: json['date'],
      images: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ownerName': ownerName,
      'postingDate': postingDate,
      'images': ''
    };
  }
}

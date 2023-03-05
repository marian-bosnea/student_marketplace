import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class SalePostEntity extends Equatable {
  String title;
  String description;
  String ownerId;
  String postingDate;
  String price;
  String categoryId;
  List<Uint8List> images;

  String? postId;
  String? ownerName;
  String? categoryName;

  SalePostEntity(
      {required this.title,
      required this.description,
      required this.ownerId,
      required this.categoryId,
      required this.postingDate,
      required this.price,
      required this.images,
      this.postId,
      this.ownerName,
      this.categoryName});

  @override
  List<Object?> get props => [
        title,
        description,
        ownerId,
        postingDate,
        images,
        price,
        categoryId,
        postId,
        ownerId,
        ownerName
      ];
}

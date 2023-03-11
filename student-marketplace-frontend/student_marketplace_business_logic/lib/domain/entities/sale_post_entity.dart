import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class SalePostEntity extends Equatable {
  String title;
  String? description;
  String? ownerId;
  String? postingDate;
  String price;
  String? categoryId;
  final List<Uint8List> images;

  int? viewsCount;
  String? postId;
  String? ownerName;
  String? categoryName;

  SalePostEntity(
      {required this.title,
      this.description,
      this.ownerId,
      this.categoryId,
      this.postingDate,
      this.viewsCount,
      required this.price,
      required this.images,
      this.postId,
      this.ownerName,
      this.categoryName});

  @override
  List<Object?> get props => [
        title,
        description,
        categoryName,
        ownerId,
        postingDate,
        images,
        price,
        categoryId,
        postId,
        ownerName,
        viewsCount
      ];
}

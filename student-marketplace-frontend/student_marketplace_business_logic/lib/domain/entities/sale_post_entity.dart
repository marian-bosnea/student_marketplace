import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class SalePostEntity extends Equatable {
  String price;
  String title;
  final List<Uint8List> images;

  int? postId;
  int? ownerId;
  int? categoryId;
  String? description;
  String? postingDate;
  String? ownerName;
  String? categoryName;

  bool? isFavorite;
  bool? isOwn;

  int? viewsCount;

  SalePostEntity(
      {required this.title,
      required this.images,
      required this.price,
      this.description,
      this.ownerId,
      this.categoryId,
      this.viewsCount,
      this.postId,
      this.ownerName,
      this.categoryName,
      this.isFavorite,
      this.isOwn,
      this.postingDate});

  @override
  List<Object?> get props => [
        price,
        title,
        images,
        postId,
        ownerId,
        categoryId,
        description,
        postingDate,
        ownerName,
        categoryName,
        viewsCount,
        isFavorite,
        isOwn
      ];
}

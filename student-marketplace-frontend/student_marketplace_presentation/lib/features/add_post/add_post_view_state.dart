import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/product_category_entity.dart';

enum AddPostPageStatus { initial, submittind, submittedSuccesfully }

class AddPostState extends Equatable {
  final String titleValue;
  final String descriptionValue;
  final int categoryId;
  final String price;
  final List<ProductCategoryEntity> categories;
  final List<Uint8List> images;

  final AddPostPageStatus status;
  const AddPostState(
      {this.titleValue = '',
      this.descriptionValue = '',
      this.categoryId = 0,
      this.price = '',
      this.images = const [],
      this.categories = const [],
      this.status = AddPostPageStatus.initial});

  AddPostState copyWith({
    String? titleValue,
    String? descriptionValue,
    int? categoryId,
    String? price,
    List<ProductCategoryEntity>? categories,
    List<Uint8List>? images,
    AddPostPageStatus? status,
  }) {
    return AddPostState(
      titleValue: titleValue ?? this.titleValue,
      descriptionValue: descriptionValue ?? this.descriptionValue,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      images: images ?? this.images,
      categories: categories ?? this.categories,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        titleValue,
        descriptionValue,
        categoryId,
        price,
        images,
        categories,
        status
      ];
}

import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/product_category_entity.dart';

enum AddPostPageStatus { initial, submittind, submittedSuccesfully }

class AddPostState extends Equatable {
  final String title;
  final String description;
  final int categoryId;
  final String price;
  final List<ProductCategoryEntity> categories;
  final List<Uint8List> images;

  final int currentStep;
  final AddPostPageStatus status;

  final bool isUpdating;

  final int? postId;

  const AddPostState(
      {this.title = '',
      this.postId,
      this.description = '',
      this.categoryId = -1,
      this.currentStep = 0,
      this.price = '',
      this.images = const [],
      this.categories = const [],
      this.isUpdating = false,
      this.status = AddPostPageStatus.initial});

  AddPostState copyWith({
    String? title,
    String? description,
    int? categoryId,
    String? price,
    int? currentStep,
    bool? isUpdating,
    List<ProductCategoryEntity>? categories,
    int? postId,
    List<Uint8List>? images,
    AddPostPageStatus? status,
  }) {
    return AddPostState(
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      postId: postId ?? this.postId,
      images: images ?? this.images,
      isUpdating: isUpdating ?? this.isUpdating,
      categories: categories ?? this.categories,
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        categoryId,
        price,
        images,
        categories,
        currentStep,
        status,
        isUpdating,
        postId
      ];
}

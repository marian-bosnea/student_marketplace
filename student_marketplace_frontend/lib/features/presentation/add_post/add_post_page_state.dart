import 'dart:typed_data';

import 'package:equatable/equatable.dart';

enum AddPostPageStatus { initial, submittind, submittedSuccesfully }

class AddPostPageState extends Equatable {
  final String titleValue;
  final String descriptionValue;
  final String categoryId;
  final String price;
  final List<Uint8List> images;

  const AddPostPageState(
      {this.titleValue = '',
      this.descriptionValue = '',
      this.categoryId = '',
      this.price = '',
      this.images = const []});

  AddPostPageState copyWith(
      {String? titleValue,
      String? descriptionValue,
      String? categoryId,
      String? price,
      List<Uint8List>? images}) {
    return AddPostPageState(
        titleValue: titleValue ?? this.titleValue,
        descriptionValue: descriptionValue ?? this.descriptionValue,
        categoryId: categoryId ?? this.categoryId,
        price: price ?? this.price,
        images: images ?? this.images);
  }

  @override
  List<Object?> get props => [];
}

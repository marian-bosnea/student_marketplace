import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../core/constants/enums.dart';

class DetailedPostViewState extends Equatable {
  final SalePostEntity? post;
  final int? selectedImageIndex;
  final bool isFavorite;
  final PostsViewStatus status;

  const DetailedPostViewState(
      {this.selectedImageIndex = 0,
      this.isFavorite = false,
      this.post,
      this.status = PostsViewStatus.initial});

  DetailedPostViewState copyWith(
      {int? selectedImageIndex,
      SalePostEntity? post,
      bool? isFavorite,
      PostsViewStatus? status}) {
    return DetailedPostViewState(
        selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
        isFavorite: isFavorite ?? this.isFavorite,
        post: post ?? this.post,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [selectedImageIndex, isFavorite, post, status];
}

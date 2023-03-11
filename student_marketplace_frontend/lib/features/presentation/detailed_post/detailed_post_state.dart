import 'package:equatable/equatable.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';

class DetailedPostPageState extends Equatable {
  final SalePostEntity? post;
  final int? selectedImageIndex;
  final bool isFavorite;
  final PostsViewStatus status;

  const DetailedPostPageState(
      {this.selectedImageIndex = 0,
      this.isFavorite = false,
      this.post,
      this.status = PostsViewStatus.initial});

  DetailedPostPageState copyWith(
      {int? selectedImageIndex,
      SalePostEntity? post,
      bool? isFavorite,
      PostsViewStatus? status}) {
    return DetailedPostPageState(
        selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
        isFavorite: isFavorite ?? this.isFavorite,
        post: post ?? this.post,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [selectedImageIndex, isFavorite, post, status];
}

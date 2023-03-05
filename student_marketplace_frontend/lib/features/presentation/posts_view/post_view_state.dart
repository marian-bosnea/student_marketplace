// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:student_marketplace_frontend/features/data/models/sale_post_model.dart';
import 'package:student_marketplace_frontend/features/domain/entities/product_category_entity.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';

import '../../../core/enums.dart';

class PostViewState extends Equatable {
  final List<SalePostEntity> posts;
  final List<ProductCategoryEntity> categories;

  final int selectedCategoryIndex;
  final PostsViewStatus status;

  const PostViewState(
      {this.posts = const [],
      this.selectedCategoryIndex = -1,
      this.categories = const [],
      this.status = PostsViewStatus.initial});

  PostViewState copyWith(
          {List<SalePostEntity>? posts,
          List<ProductCategoryEntity>? categories,
          int? selectedCategoryIndex,
          PostsViewStatus? status}) =>
      PostViewState(
          posts: posts ?? this.posts,
          selectedCategoryIndex:
              selectedCategoryIndex ?? this.selectedCategoryIndex,
          categories: categories ?? this.categories,
          status: status ?? this.status);

  @override
  List<Object?> get props => [posts, categories, status, selectedCategoryIndex];
}

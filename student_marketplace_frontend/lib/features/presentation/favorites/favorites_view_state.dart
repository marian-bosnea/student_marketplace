import 'package:equatable/equatable.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';

class FavoritesViewState extends Equatable {
  final PostsViewStatus status;
  final List<SalePostEntity> posts;

  const FavoritesViewState(
      {this.status = PostsViewStatus.initial, this.posts = const []});

  FavoritesViewState copyWith(
          {PostsViewStatus? status, List<SalePostEntity>? posts}) =>
      FavoritesViewState(
          posts: posts ?? this.posts, status: status ?? this.status);
  @override
  List<Object?> get props => [posts, status];
}

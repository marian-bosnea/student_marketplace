import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../core/constants/enums.dart';

class OwnPostsViewState extends Equatable {
  final PostsViewStatus status;
  final List<SalePostEntity> posts;

  const OwnPostsViewState(
      {this.status = PostsViewStatus.initial, this.posts = const []});

  OwnPostsViewState copyWith(
          {PostsViewStatus? status, List<SalePostEntity>? posts}) =>
      OwnPostsViewState(
          posts: posts ?? this.posts, status: status ?? this.status);
  @override
  List<Object?> get props => [posts, status];
}

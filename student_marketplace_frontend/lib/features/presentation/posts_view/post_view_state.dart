// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:student_marketplace_frontend/features/data/models/sale_post_model.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';

import '../../../core/enums.dart';

class PostViewState extends Equatable {
  final List<SalePostEntity> posts;
  final PostsViewStatus status;

  const PostViewState(
      {this.posts = const [], this.status = PostsViewStatus.initial});

  PostViewState copyWith(
          {List<SalePostEntity>? posts, PostsViewStatus? status}) =>
      PostViewState(posts: posts ?? this.posts, status: status ?? this.status);

  @override
  List<Object?> get props => [posts, status];
}

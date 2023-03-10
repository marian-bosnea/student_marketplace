import 'package:equatable/equatable.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';

enum SearchPageStatus { initial, loading, loaded, fail }

class SearchPageState extends Equatable {
  final List<SalePostEntity> posts;
  final SearchPageStatus status;

  const SearchPageState(
      {this.status = SearchPageStatus.initial, this.posts = const []});

  SearchPageState copyWith(
          {SearchPageStatus? status, List<SalePostEntity>? posts}) =>
      SearchPageState(
          status: status ?? this.status, posts: posts ?? this.posts);

  @override
  List<Object?> get props => [posts, status];
}

import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

enum SearchPageStatus { initial, loading, loaded, fail }

class SearchViewState extends Equatable {
  final List<SalePostEntity> posts;
  final SearchPageStatus status;

  const SearchViewState(
      {this.status = SearchPageStatus.initial, this.posts = const []});

  SearchViewState copyWith(
          {SearchPageStatus? status, List<SalePostEntity>? posts}) =>
      SearchViewState(
          status: status ?? this.status, posts: posts ?? this.posts);

  @override
  List<Object?> get props => [posts, status];
}

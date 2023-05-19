import 'package:equatable/equatable.dart';

enum SearchViewStatus { intial, loading, loaded }

class SearchViewState extends Equatable {
  SearchViewStatus status;
  String searchQuery;
  int selectedCategoryId;

  SearchViewState(
      {this.status = SearchViewStatus.intial,
      this.searchQuery = '',
      this.selectedCategoryId = -1});

  SearchViewState copyWith(
          {SearchViewStatus? status,
          String? searchQuery,
          int? selectedCategoryId}) =>
      SearchViewState(
          status: status ?? this.status,
          searchQuery: searchQuery ?? this.searchQuery,
          selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId);

  @override
  List<Object?> get props => [status, searchQuery, selectedCategoryId];
}

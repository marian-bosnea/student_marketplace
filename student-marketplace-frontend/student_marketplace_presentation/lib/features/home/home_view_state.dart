// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class HomeViewState extends Equatable {
  final String title;

  final int currentPageIndex;

  final String searchHint;

  const HomeViewState({
    this.currentPageIndex = 0,
    this.title = 'Discover',
    this.searchHint = 'Search',
  });

  HomeViewState copyWith(
      {String? title,
      int? currentPageIndex,
      Uint8List? profileIcon,
      bool? hasLoadedPosts,
      bool? hasLoadedProfile,
      String? searchHint,
      bool? shouldRefreshPosts}) {
    return HomeViewState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      title: title ?? this.title,
      searchHint: searchHint ?? this.searchHint,
    );
  }

  @override
  List<Object?> get props => [currentPageIndex, title, searchHint];
}

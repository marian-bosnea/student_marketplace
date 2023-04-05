// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../core/constants/enums.dart';

class HomeViewState extends Equatable {
  final HomePageStatus status;
  final String title;
  final bool hasLoadedPosts;
  final bool hasLoadedProfile;
  final Uint8List? profileIcon;

  final bool shouldRefreshPosts;
  final String searchHint;

  const HomeViewState(
      {this.status = HomePageStatus.home,
      this.hasLoadedPosts = false,
      this.hasLoadedProfile = false,
      this.title = 'Discover',
      this.searchHint = 'Search',
      this.profileIcon,
      this.shouldRefreshPosts = false});

  HomeViewState copyWith(
      {String? title,
      HomePageStatus? status,
      Uint8List? profileIcon,
      bool? hasLoadedPosts,
      bool? hasLoadedProfile,
      String? searchHint,
      bool? shouldRefreshPosts}) {
    return HomeViewState(
        status: status ?? this.status,
        title: title ?? this.title,
        profileIcon: profileIcon,
        searchHint: searchHint ?? this.searchHint,
        hasLoadedPosts: hasLoadedPosts ?? this.hasLoadedPosts,
        hasLoadedProfile: hasLoadedProfile ?? this.hasLoadedProfile,
        shouldRefreshPosts: shouldRefreshPosts ?? this.shouldRefreshPosts);
  }

  @override
  List<Object?> get props => [
        status,
        title,
        profileIcon,
        hasLoadedPosts,
        hasLoadedProfile,
        shouldRefreshPosts,
        searchHint
      ];
}

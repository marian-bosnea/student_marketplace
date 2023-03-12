// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../core/constants/enums.dart';

class HomePageState extends Equatable {
  final HomePageStatus status;
  final String title;
  final Uint8List? profileIcon;

  const HomePageState(
      {this.status = HomePageStatus.home,
      this.title = 'Discover',
      this.profileIcon});

  HomePageState copyWith(
      {String? title, HomePageStatus? status, Uint8List? profileIcon}) {
    return HomePageState(
        status: status ?? this.status,
        title: title ?? this.title,
        profileIcon: profileIcon);
  }

  @override
  List<Object?> get props => [status, title, profileIcon];
}

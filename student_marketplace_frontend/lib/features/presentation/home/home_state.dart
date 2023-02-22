// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../core/enums.dart';

class HomePageState extends Equatable {
  final HomePageStatus status;
  final String title;

  const HomePageState(
      {this.status = HomePageStatus.home, this.title = 'UniTBv Marketplace'});

  HomePageState copyWith({String? title, HomePageStatus? status}) {
    return HomePageState(
        status: status ?? this.status, title: title ?? this.title);
  }

  @override
  List<Object?> get props => [status];
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../core/enums.dart';

class HomePageState extends Equatable {
  final HomePageStatus status;

  const HomePageState({
    this.status = HomePageStatus.home,
  });

  HomePageState copyWith({HomePageStatus? status}) {
    return HomePageState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}

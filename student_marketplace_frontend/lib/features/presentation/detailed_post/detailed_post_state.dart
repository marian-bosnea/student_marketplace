import 'package:equatable/equatable.dart';

class DetailedPostPageState extends Equatable {
  final int? selectedImageIndex;

  DetailedPostPageState({this.selectedImageIndex = 0});

  DetailedPostPageState copyWith({int? selectedImageIndex}) {
    return DetailedPostPageState(
        selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex);
  }

  @override
  List<Object?> get props => [selectedImageIndex];
}

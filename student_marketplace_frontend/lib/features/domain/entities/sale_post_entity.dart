import 'package:equatable/equatable.dart';

class SalePostEntity extends Equatable {
  String title;
  String description;
  String ownerName;
  String postingDate;
  List<String> images;

  SalePostEntity(
      {required this.title,
      required this.description,
      required this.ownerName,
      required this.postingDate,
      required this.images});

  @override
  List<Object?> get props =>
      [title, description, ownerName, postingDate, images];
}

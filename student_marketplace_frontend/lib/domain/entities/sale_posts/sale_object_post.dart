import 'package:equatable/equatable.dart';

class SalePost extends Equatable {
  final String ownerName;
  final String title;
  final String description;
  final double price;
  final String category;

  const SalePost(
      {required this.ownerName,
      required this.title,
      required this.description,
      required this.price,
      required this.category});

  @override
  List<Object?> get props => [ownerName, title, description, price, category];
}

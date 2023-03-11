import 'package:equatable/equatable.dart';

abstract class ProductCategoryEntity extends Equatable {
  final int id;
  final String name;

  const ProductCategoryEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

import 'package:equatable/equatable.dart';

abstract class AddressEntity extends Equatable {
  final int? id;
  final String name;
  final String county;
  final String city;
  final String description;

  AddressEntity(
      {this.id,
      required this.name,
      required this.city,
      required this.description,
      required this.county});

  @override
  List<Object?> get props => [id, name, city, county, description];
}

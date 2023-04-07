import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel(
      {super.id,
      required super.name,
      required super.city,
      required super.description,
      required super.county});

  static AddressModel fromJson(Map<String, dynamic> json) => AddressModel(
      id: json['id'] as int,
      name: json['name'] as String,
      city: json['city'] as String,
      description: json['description'] as String,
      county: json['county'] as String);

  Map<String, dynamic> toJson() => {
        'id': id ?? 0,
        'name': name,
        'county': county,
        'city': city,
        'description': description
      };
}

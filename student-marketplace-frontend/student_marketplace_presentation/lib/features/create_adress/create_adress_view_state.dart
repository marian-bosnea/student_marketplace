import 'package:equatable/equatable.dart';

enum AddressCreationStatus { inProgress, succesfulSubmitted, failSubmitted }

class CreateAddressViewState extends Equatable {
  final String name;
  final String county;
  final String city;
  final String description;

  const CreateAddressViewState(
      {this.county = '',
      this.city = '',
      this.description = '',
      this.name = ''});

  CreateAddressViewState copyWith(
          {String? name, String? county, String? city, String? description}) =>
      CreateAddressViewState(
          name: name ?? this.name,
          county: county ?? this.county,
          city: city ?? this.city,
          description: description ?? this.description);

  @override
  List<Object?> get props => [name, county, city, description];
}

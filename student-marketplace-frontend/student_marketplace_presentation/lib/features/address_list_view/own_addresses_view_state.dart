import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

enum AddressesViewStatus { initial, loading, success, fail }

class OwnAddressesViewState extends Equatable {
  final List<AddressEntity> addresses;
  final AddressesViewStatus status;

  const OwnAddressesViewState(
      {this.addresses = const [], this.status = AddressesViewStatus.initial});

  OwnAddressesViewState copyWith(
          {List<AddressEntity>? addresses, AddressesViewStatus? status}) =>
      OwnAddressesViewState(
          addresses: addresses ?? this.addresses,
          status: status ?? this.status);

  @override
  List<Object?> get props => [addresses, status];
}

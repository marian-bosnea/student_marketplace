import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

class CreateOrderViewState extends Equatable {
  final SalePostEntity? post;
  final AddressEntity? address;
  final String notes;
  final String date;

  const CreateOrderViewState({
    this.post,
    this.address,
    this.notes = '',
    this.date = '',
  });

  CreateOrderViewState copyWith(
          {SalePostEntity? post,
          AddressEntity? address,
          String? notes,
          String? date}) =>
      CreateOrderViewState(
          post: post ?? this.post,
          address: address ?? this.address,
          notes: notes ?? this.notes,
          date: date ?? this.date);

  @override
  List<Object?> get props => [post, address, notes, date];
}

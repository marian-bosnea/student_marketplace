import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

class CreateOrderViewState extends Equatable {
  final SalePostEntity? post;
  final List<AddressEntity> addresses;
  final int? selectedAddressId;
  final String notes;
  final String date;

  final int currentStep;

  const CreateOrderViewState(
      {this.post,
      this.selectedAddressId = 0,
      this.notes = '',
      this.date = '',
      this.addresses = const [],
      this.currentStep = 0});

  CreateOrderViewState copyWith(
          {SalePostEntity? post,
          List<AddressEntity>? addresses,
          int? selectedAddressId,
          String? notes,
          String? date,
          int? currentStep}) =>
      CreateOrderViewState(
          post: post ?? this.post,
          selectedAddressId: selectedAddressId ?? this.selectedAddressId,
          notes: notes ?? this.notes,
          addresses: addresses ?? this.addresses,
          currentStep: currentStep ?? this.currentStep,
          date: date ?? this.date);

  @override
  List<Object?> get props =>
      [post, selectedAddressId, notes, date, currentStep, addresses];
}

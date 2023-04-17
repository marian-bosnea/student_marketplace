import 'package:equatable/equatable.dart';

enum OrderStatus { pending, accepted, declined, toCourier, delivered }

abstract class OrderEntity extends Equatable {
  final int? id;
  final int? partnerId;
  final int objectId;
  final int? addressId;
  final String? partnerName;
  final String? objectTitle;
  final String? addressDescription;
  final String notes;
  final String? awb;
  final String lastModifiedDate;

  final OrderStatus status;

  OrderEntity(
      {this.id,
      this.partnerId,
      this.partnerName,
      this.objectTitle,
      this.addressDescription,
      this.awb,
      required this.lastModifiedDate,
      required this.notes,
      this.addressId,
      required this.objectId,
      required this.status});

  @override
  List<Object?> get props => [
        id,
        partnerId,
        partnerName,
        objectTitle,
        addressDescription,
        awb,
        lastModifiedDate,
        notes,
        addressId,
        objectId,
        status
      ];
}

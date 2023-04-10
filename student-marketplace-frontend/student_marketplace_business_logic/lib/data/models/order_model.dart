import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_business_logic/domain/repositories/order_repository.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.partnerId,
    required super.lastModifiedDate,
    required super.notes,
    required super.status,
    super.addressDescription,
    super.addressId,
    super.awb,
    required super.objectId,
    super.objectTitle,
    super.id,
    super.partnerName,
  });

  static OrderStatus statusFromId(int id) {
    switch (id) {
      case 1:
        return OrderStatus.accepted;
      case -1:
        return OrderStatus.declined;
      case 2:
        return OrderStatus.toCourier;
      case 3:
        return OrderStatus.delivered;

      default:
        return OrderStatus.pending;
    }
  }

  Map<String, dynamic> toJson() => {
        'object_id': objectId,
        'address_id': addressId,
        'notes': notes,
        'date': lastModifiedDate,
      };

  static OrderModel fromJson(Map<String, dynamic> json) {
    final statusId = json['status'] as int;

    return OrderModel(
      id: json['id'] as int,
      objectId: json['object_id'] as int,
      objectTitle: json['object_title'] as String,
      partnerId: json['partner_id'] as int,
      partnerName: json['partner_name'] as String,
      addressDescription: json['address_name'] as String,
      awb: json['awb'] as String,
      lastModifiedDate: json['date'],
      notes: json['notes'],
      status: statusFromId(statusId),
    );
  }
}

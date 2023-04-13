import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';

class ReceivedDetailedOrderViewState extends Equatable {
  final int id;
  final OrderStatus orderStatus;
  final String lastModifiedDate;
  final String awb;

  const ReceivedDetailedOrderViewState(
      {this.id = 0,
      this.orderStatus = OrderStatus.pending,
      this.lastModifiedDate = '',
      this.awb = ''});

  ReceivedDetailedOrderViewState copyWith(
          {int? id,
          OrderStatus? orderStatus,
          String? lastModifiedDate,
          String? awb}) =>
      ReceivedDetailedOrderViewState(
          id: id ?? this.id,
          orderStatus: orderStatus ?? this.orderStatus,
          lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
          awb: awb ?? this.awb);

  @override
  List<Object?> get props => [id, orderStatus, lastModifiedDate, awb];
}

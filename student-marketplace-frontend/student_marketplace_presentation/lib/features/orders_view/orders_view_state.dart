import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';

enum OrdersViewType { sent, received }

enum OrdersViewStatus { initial, loading, loaded }

class OrdersViewState extends Equatable {
  final OrdersViewType type;
  final OrdersViewStatus receivedOrdersStatus;
  final OrdersViewStatus sentOrdersStatus;

  final List<OrderEntity> receivedOrders;
  final List<OrderEntity> sentOrders;

  const OrdersViewState(
      {this.type = OrdersViewType.sent,
      this.sentOrdersStatus = OrdersViewStatus.initial,
      this.receivedOrdersStatus = OrdersViewStatus.initial,
      this.receivedOrders = const [],
      this.sentOrders = const []});

  OrdersViewState copyWith({
    OrdersViewType? type,
    OrdersViewStatus? receivedOrdersStatus,
    OrdersViewStatus? sentOrdersStatus,
    List<OrderEntity>? sentOrders,
    List<OrderEntity>? receivedOrders,
  }) =>
      OrdersViewState(
          type: type ?? this.type,
          sentOrdersStatus: sentOrdersStatus ?? this.sentOrdersStatus,
          receivedOrdersStatus:
              receivedOrdersStatus ?? this.receivedOrdersStatus,
          sentOrders: sentOrders ?? this.sentOrders,
          receivedOrders: receivedOrders ?? this.receivedOrders);

  @override
  List<Object?> get props => [
        type,
        receivedOrdersStatus,
        sentOrdersStatus,
        receivedOrders,
        sentOrders
      ];
}

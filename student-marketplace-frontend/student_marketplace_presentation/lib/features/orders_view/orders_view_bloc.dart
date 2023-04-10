import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/orders/get_orders_by_buyer_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/orders/get_orders_by_seller_usecase.dart';

import '../../core/config/injection_container.dart';
import 'orders_view_state.dart';

class OrdersViewBloc extends Cubit<OrdersViewState> {
  late GetOrdersByBuyerUsecase getOrdersByBuyerUsecase;
  late GetOrdersBySellerUsecase getOrdersBySellerUsecase;

  OrdersViewBloc() : super(const OrdersViewState()) {
    getOrdersByBuyerUsecase = GetOrdersByBuyerUsecase(
        authRepository: sl.call(), orderRepository: sl.call());

    getOrdersBySellerUsecase = GetOrdersBySellerUsecase(
        authRepository: sl.call(), orderRepository: sl.call());
  }

  Future<void> fetchSentOrders() async {
    emit(state.copyWith(sentOrdersStatus: OrdersViewStatus.loading));

    final result = await getOrdersByBuyerUsecase(NoParams());

    if (result is Left) {
      emit(state.copyWith(sentOrdersStatus: OrdersViewStatus.initial));
      return;
    }

    final orders = (result as Right).value;

    emit(state.copyWith(
        sentOrdersStatus: OrdersViewStatus.loaded, sentOrders: orders));
  }

  Future<void> fetchReceivedOrders() async {
    emit(state.copyWith(receivedOrdersStatus: OrdersViewStatus.loading));

    final result = await getOrdersBySellerUsecase(NoParams());

    if (result is Left) {
      emit(state.copyWith(receivedOrdersStatus: OrdersViewStatus.initial));
      return;
    }

    final orders = (result as Right).value;

    emit(state.copyWith(
        sentOrdersStatus: OrdersViewStatus.loaded, receivedOrders: orders));
  }

  void setViewType(int index) {
    if (index < 2) {
      if (index == 0) {
        fetchSentOrders();
      } else {
        fetchReceivedOrders();
      }
      emit(state.copyWith(type: OrdersViewType.values[index]));
    }
  }
}

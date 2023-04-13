import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/order_model.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/orders/update_order_usecase.dart';
import 'package:student_marketplace_presentation/core/utils/date_formater.dart';
import 'package:student_marketplace_presentation/features/detailed_order/received_detailed_order_view_state.dart';

import '../../core/config/injection_container.dart';

class ReceivedDetailedOrderViewBloc
    extends Cubit<ReceivedDetailedOrderViewState> {
  late UpdateOrderUsecase updateOrderUsecase;
  ReceivedDetailedOrderViewBloc()
      : super(const ReceivedDetailedOrderViewState()) {
    updateOrderUsecase = sl.call();
  }

  void init(int id, OrderStatus status, String awb, String lastModifiedDate) {
    emit(state.copyWith(
        id: id,
        orderStatus: status,
        awb: awb,
        lastModifiedDate: lastModifiedDate));
  }

  void setStatus(OrderStatus status) {
    emit(state.copyWith(
        orderStatus: status, lastModifiedDate: getCurrentDateFormatted()));
    updateOrder();
  }

  void setAWB(String awb) {
    emit(state.copyWith(awb: awb, lastModifiedDate: getCurrentDateFormatted()));
    updateOrder();
  }

  Future<void> updateOrder() async {
    await updateOrderUsecase(OrderParam(
        order: OrderModel(
      partnerId: 0,
      lastModifiedDate: getCurrentDateFormatted(),
      objectId: 0,
      awb: state.awb,
      notes: '',
      id: state.id,
      status: state.orderStatus,
    )));
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/order_model.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/orders/create_order_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/orders/get_addresses_usecase.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';
import 'package:student_marketplace_presentation/core/utils/date_formater.dart';
import 'package:student_marketplace_presentation/features/create_order/create_order_view_state.dart';

import '../../core/config/injection_container.dart';

class CreateOrderViewBloc extends Cubit<CreateOrderViewState> {
  late CreateOrderUsecase createOrderUsecase;
  late GetAddressesUsecase getAddressesUsecase;

  CreateOrderViewBloc() : super(const CreateOrderViewState()) {
    createOrderUsecase = sl.call();
    getAddressesUsecase = sl.call();
  }

  Future<void> init(SalePostEntity post) async {
    final result = await getAddressesUsecase(NoParams());
    if (result is Left) {
      emit(state.copyWith(post: post));
    }
    final addresses = (result as Right).value;
    emit(state.copyWith(post: post, addresses: addresses));

    if (addresses.isNotEmpty) {
      emit(state.copyWith(selectedAddressId: addresses.first.id));
    }
  }

  bool canGoToNextStep() => true;

  void goToNextStep(BuildContext context) {
    if (state.currentStep != 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    } else {
      createOrderUsecase(OrderParam(
          order: OrderModel(
        objectId: state.post!.postId!,
        addressId: state.selectedAddressId,
        partnerId: 0,
        status: OrderStatus.pending,
        notes: state.notes,
        lastModifiedDate: getCurrentDateFormatted(),
      )));
      Navigator.of(context).pushReplacementNamed(PageNames.homePage);
    }
  }

  void setAddressId(int id) => emit(state.copyWith(selectedAddressId: id));

  void setNotes(String notes) => emit(state.copyWith(notes: notes));

  void goToPreviousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }
}

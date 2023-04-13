import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/create_order/create_order_view_state.dart';

class CreateOrderViewBloc extends Cubit<CreateOrderViewState> {
  CreateOrderViewBloc() : super(const CreateOrderViewState());

  void init(SalePostEntity post) {
    emit(state.copyWith(post: post));
  }
}

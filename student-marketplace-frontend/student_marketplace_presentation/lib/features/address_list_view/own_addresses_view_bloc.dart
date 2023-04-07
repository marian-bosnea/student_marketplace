import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/orders/delete_address_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/orders/get_addresses_usecase.dart';

import '../../core/config/injection_container.dart';
import 'own_addresses_view_state.dart';

class OwnAddressesViewBloc extends Cubit<OwnAddressesViewState> {
  late GetAddressesUsecase getAddressesUsecase;
  late DeleteAddressUsecase deleteAddressUsecase;

  OwnAddressesViewBloc() : super(const OwnAddressesViewState()) {
    deleteAddressUsecase = DeleteAddressUsecase(
        authRepository: sl.call(), addressOperations: sl.call());
    getAddressesUsecase = GetAddressesUsecase(
        authRepository: sl.call(), addressRepository: sl.call());
  }

  Future<void> fetchAllAddresses() async {
    emit(state.copyWith(status: AddressesViewStatus.loading));

    final result = await getAddressesUsecase(NoParams());
    if (result is Left) {
      emit(state.copyWith(status: AddressesViewStatus.fail));
      return;
    }

    final addresses = (result as Right).value;

    emit(state.copyWith(
        addresses: addresses, status: AddressesViewStatus.success));
  }

  Future<void> deleteAddress(AddressEntity address) async {
    await deleteAddressUsecase(AddressParam(address: address));
    await fetchAllAddresses();
  }
}

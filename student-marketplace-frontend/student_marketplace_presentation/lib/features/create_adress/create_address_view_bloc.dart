import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/address_model.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/orders/create_address_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/orders/update_address_usecase.dart';
import 'package:student_marketplace_presentation/features/create_adress/create_adress_view_state.dart';

import '../../core/config/injection_container.dart';

class CreateAddressViewBloc extends Cubit<CreateAddressViewState> {
  late CreateAddressUsecase createAddressUsecase;
  late UpdateAddressUsecase updateAddressUsecase;

  CreateAddressViewBloc() : super(const CreateAddressViewState()) {
    updateAddressUsecase = UpdateAddressUsecase(
        authRepository: sl.call(), addressOperations: sl.call());
    createAddressUsecase = CreateAddressUsecase(
        authRepository: sl.call(), addressOperations: sl.call());
  }
  void init(AddressEntity? address) {
    if (address != null) {
      emit(state.copyWith(
          name: address.name,
          description: address.description,
          city: address.city,
          county: address.county));
    }
  }

  void setCountyValue(String text) {
    emit(state.copyWith(county: text));
  }

  void setDescriptionValue(String text) {
    emit(state.copyWith(description: text));
  }

  void setCityValue(String text) {
    emit(state.copyWith(city: text));
  }

  void setNameValue(String text) {
    emit(state.copyWith(name: text));
  }

  Future<void> submit(int? id) async {
    if (id != null) {
      updateAddressUsecase(AddressParam(
          address: AddressModel(
              id: id,
              name: state.name,
              description: state.description,
              county: state.county,
              city: state.city)));
    } else {
      createAddressUsecase(AddressParam(
          address: AddressModel(
              name: state.name,
              city: state.city,
              county: state.county,
              description: state.description)));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/user_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/deauthenticate_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/get_user_usecase.dart';

import '../../core/constants/enums.dart';
import 'account_view_state.dart';

class AccountViewBloc extends Cubit<AccountViewState> {
  final GetUserProfile getUserUsecase;
  final DeauthenticateUsecase deauthenticateUsecase;

  AccountViewBloc(
      {required this.getUserUsecase, required this.deauthenticateUsecase})
      : super(const AccountViewState());

  Future<void> logout(BuildContext context) async {
    await deauthenticateUsecase(NoParams());
    Navigator.of(context).pushReplacementNamed('/');
  }

  Future<void> fetchUserProfile(int? id) async {
    emit(state.copyWith(status: ProfilePageStatus.loading));

    //final result = await getUserUsecase(OptionalIdParam(id: id));
    final result = await getUserUsecase(OptionalIdParam());

    if (result is Right) {
      final user = result.getOrElse(() => const UserModel());
      emit(state.copyWith(
          firstName: user.firstName,
          lastName: user.lastName,
          secondLastName: user.secondaryLastName,
          emailAdress: user.email,
          avatarBytes: user.avatarImage,
          facultyName: user.facultyName,
          status: ProfilePageStatus.loaded));
    } else {}
  }
}

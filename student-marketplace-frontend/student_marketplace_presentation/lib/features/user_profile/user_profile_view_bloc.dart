import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/user_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/get_user_usecase.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_state.dart';

import '../../core/constants/enums.dart';

class UserProfileViewBloc extends Cubit<UserProfileViewState> {
  final GetUserProfile getUserUsecase;

  UserProfileViewBloc({required this.getUserUsecase})
      : super(const UserProfileViewState());

  Future<void> fetchUserProfile(int? id) async {
    emit(state.copyWith(status: ProfilePageStatus.loading));

    final result = await getUserUsecase(OptionalIdParam(id: id));

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

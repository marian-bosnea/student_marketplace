import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/user_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/get_own_user_usecase.dart';
import 'package:student_marketplace_presentation/features/user_profile/profile_view_state.dart';

import '../../core/constants/enums.dart';

class ProfileViewBloc extends Cubit<ProfileViewState> {
  final GetOwnUserProfile getUserUsecase;
  late ProfileViewState state = const ProfileViewState();

  ProfileViewBloc({required this.getUserUsecase})
      : super(const ProfileViewState());

  Future<void> fetchUserProfile() async {
    emit(state.copyWith(status: ProfilePageStatus.loading));
    final sharedPrefs = await SharedPreferences.getInstance();
    final token = sharedPrefs.getString('authorizationToken');

    if (token == null) {
      emit(state.copyWith(status: ProfilePageStatus.initial));
      return;
    }

    final result = await getUserUsecase(NoParams());

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

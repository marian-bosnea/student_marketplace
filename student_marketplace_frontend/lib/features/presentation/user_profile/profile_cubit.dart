import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/data/models/user_model.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/user/get_own_user_usecase.dart';
import 'package:student_marketplace_frontend/features/presentation/user_profile/profile_page_state.dart';

class ProfileCubit extends Cubit<ProfilePageState> {
  final GetOwnUserProfile getUserUsecase;
  late ProfilePageState state = ProfilePageState();

  ProfileCubit({required this.getUserUsecase}) : super(ProfilePageState());

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

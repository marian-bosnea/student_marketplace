import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/user_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/get_own_user_usecase.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';

import '../../core/constants/enums.dart';
import 'home_state.dart';

class HomePageBloc extends Cubit<HomePageState> {
  final GetOwnUserProfile getOwnUserProfileUsecase;

  late HomePageState state = HomePageState();

  HomePageBloc({required this.getOwnUserProfileUsecase})
      : super(const HomePageState());

  void goToHome() {
    state = state.copyWith(status: HomePageStatus.home, title: "Discover");
    emit(state);
  }

  Future<void> fetchProfilePhoto() async {
    final result = await getOwnUserProfileUsecase(NoParams());

    if (result is Right) {
      final user = result.getOrElse(() => const UserModel());
      state = state.copyWith(profileIcon: user.avatarImage);
      emit(state);
    } else {}
  }

  void goToSearch() {
    if (state.status != HomePageStatus.search) {
      state = state.copyWith(status: HomePageStatus.search, title: "Search");
      emit(state);
    }
  }

  void goToAddPost() {
    if (state.status != HomePageStatus.addPost) {
      state =
          state.copyWith(status: HomePageStatus.addPost, title: "Sell an item");
      emit(state);
    }
  }

  void goToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(PageNames.userProfilePage);
  }

  void goToFavorites() {
    if (state.status != HomePageStatus.favorites) {
      state =
          state.copyWith(status: HomePageStatus.favorites, title: 'Favorites');
      emit(state);
    }
  }

  void goToSettings() {
    if (state.status != HomePageStatus.settings) {
      state =
          state.copyWith(status: HomePageStatus.settings, title: 'Settings');
      emit(state);
    }
  }
}

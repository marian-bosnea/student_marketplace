import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/user_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/get_own_user_usecase.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';

import '../../core/constants/enums.dart';
import '../posts_view/posts_view_cubit.dart';
import 'home_view_state.dart';

class HomeViewBloc extends Cubit<HomePageState> {
  final GetOwnUserProfile getOwnUserProfileUsecase;

  HomeViewBloc({required this.getOwnUserProfileUsecase})
      : super(const HomePageState());

  void goToHome(BuildContext context) {
    if (!state.hasLoadedPosts) {
      BlocProvider.of<PostViewCubit>(context).fetchAllCategories();
      BlocProvider.of<PostViewCubit>(context).fetchAllPosts();
      emit(state.copyWith(
          status: HomePageStatus.home,
          title: "Discover",
          hasLoadedPosts: true));
    } else {
      emit(state.copyWith(
          status: HomePageStatus.home,
          title: "Discover",
          hasLoadedPosts: true));
    }
  }

  Future<void> fetchProfilePhoto() async {
    if (!state.hasLoadedProfile) {
      final result = await getOwnUserProfileUsecase(NoParams());

      if (result is Right) {
        final user = result.getOrElse(() => const UserModel());
        emit(state.copyWith(
            profileIcon: user.avatarImage, hasLoadedProfile: true));
      }
    }
  }

  void goToSearch() {
    if (state.status != HomePageStatus.search) {
      emit(state.copyWith(status: HomePageStatus.search, title: "Search"));
    }
  }

  void goToAddPost() {
    if (state.status != HomePageStatus.addPost) {
      emit(state.copyWith(
          status: HomePageStatus.addPost, title: "Sell an item"));
    }
  }

  void goToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(PageNames.userProfilePage);
  }

  void goToFavorites() {
    if (state.status != HomePageStatus.favorites) {
      emit(
          state.copyWith(status: HomePageStatus.favorites, title: 'Favorites'));
    }
  }

  void goToSettings() {
    if (state.status != HomePageStatus.settings) {
      emit(state.copyWith(status: HomePageStatus.settings, title: 'Settings'));
      emit(state);
    }
  }
}

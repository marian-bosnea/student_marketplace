import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/user_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/get_user_usecase.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';

import '../../core/constants/enums.dart';
import '../posts_view/posts_view_bloc.dart';
import 'home_view_state.dart';

class HomeViewBloc extends Cubit<HomePageState> {
  final GetUserProfile getOwnUserProfileUsecase;

  HomeViewBloc({required this.getOwnUserProfileUsecase})
      : super(const HomePageState());

  Future<void> notifyPostItemChanged(BuildContext context) async {
    if (state.status != HomePageStatus.home) {
      BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
    }

    emit(state.copyWith(shouldRefreshPosts: true));
  }

  void goToHome(BuildContext context) {
    if (!state.hasLoadedPosts) {
      BlocProvider.of<PostViewBloc>(context).fetchAllCategories();
      BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
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
    final result = await getOwnUserProfileUsecase(OptionalIdParam());

    if (result is Right) {
      final user = result.getOrElse(() => const UserModel());
      emit(state.copyWith(
          profileIcon: user.avatarImage, hasLoadedProfile: true));
    }
  }

  void goToSearch(BuildContext context) {
    if (state.shouldRefreshPosts) {
      BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
    }

    if (state.status != HomePageStatus.search) {
      emit(state.copyWith(status: HomePageStatus.search, title: "Orders"));
    }
  }

  void goToAddPost(BuildContext context) {
    if (state.shouldRefreshPosts) {
      BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
    }

    if (state.status != HomePageStatus.addPost) {
      emit(state.copyWith(
          status: HomePageStatus.addPost, title: "Sell an item"));
    }
  }

  void goToFavorites(BuildContext context) {
    if (state.shouldRefreshPosts) {
      BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
    }

    if (state.status != HomePageStatus.favorites) {
      emit(
          state.copyWith(status: HomePageStatus.favorites, title: 'Favorites'));
    }
  }

  void goToSettings(BuildContext context) {
    if (state.shouldRefreshPosts) {
      BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
    }

    if (state.status != HomePageStatus.profile) {
      emit(state.copyWith(status: HomePageStatus.profile, title: 'Profile'));
    }
  }
}

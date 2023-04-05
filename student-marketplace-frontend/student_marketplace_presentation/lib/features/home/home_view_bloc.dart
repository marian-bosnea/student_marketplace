import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/get_user_usecase.dart';

import '../../core/constants/enums.dart';
import '../posts_view/posts_view_bloc.dart';
import 'home_view_state.dart';

class HomeViewBloc extends Cubit<HomeViewState> {
  HomeViewBloc() : super(const HomeViewState());

  void goToHome() {
    emit(state.copyWith(
        status: HomePageStatus.home, title: "Discover", hasLoadedPosts: true));
  }

  void goToOrders() {
    emit(state.copyWith(status: HomePageStatus.orders, title: "Orders"));
  }

  void goToAddPost() {
    emit(state.copyWith(status: HomePageStatus.addPost, title: "Sell an Item"));
  }

  void goToFavorites() {
    if (state.status != HomePageStatus.favorites) {
      emit(
          state.copyWith(status: HomePageStatus.favorites, title: 'Favorites'));
    }
  }

  void goToAccount() {
    if (state.status != HomePageStatus.account) {
      emit(state.copyWith(status: HomePageStatus.account, title: 'Account'));
    }
  }

  void setSearchHint(String text) {
    emit(state.copyWith(searchHint: text));
  }
}

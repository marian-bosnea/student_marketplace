import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/enums.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomePageState> {
  late HomePageState state = HomePageState();

  HomeCubit() : super(const HomePageState());

  void goToHome() {
    emit(state.copyWith(status: HomePageStatus.home, title: "Discover"));
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

  void goToProfile() {
    if (state.status != HomePageStatus.favorites) {
      emit(
          state.copyWith(status: HomePageStatus.favorites, title: "Favorites"));
    }
  }

  void goToSettings() {
    if (state.status != HomePageStatus.settings) {
      emit(state.copyWith(status: HomePageStatus.settings, title: 'Settings'));
    }
  }
}

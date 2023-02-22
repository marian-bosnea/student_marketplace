import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/features/presentation/home/home_page.dart';
import 'package:student_marketplace_frontend/features/presentation/home/home_state.dart';

class HomeCubit extends Cubit<HomePageState> {
  late HomePageState state = HomePageState();

  HomeCubit() : super(const HomePageState());

  void goToHome() {
    if (state.status != HomePageStatus.home) {
      emit(state.copyWith(status: HomePageStatus.home));
    }
  }

  void goToSearch() {
    if (state.status != HomePageStatus.search) {
      emit(state.copyWith(status: HomePageStatus.search));
    }
  }

  void goToAddPost() {
    if (state.status != HomePageStatus.addPost) {
      emit(state.copyWith(status: HomePageStatus.addPost));
    }
  }

  void goToProfile() {
    if (state.status != HomePageStatus.profile) {
      emit(state.copyWith(status: HomePageStatus.profile));
    }
  }

  void goToSettings() {
    if (state.status != HomePageStatus.settings) {
      emit(state.copyWith(status: HomePageStatus.settings));
    }
  }
}

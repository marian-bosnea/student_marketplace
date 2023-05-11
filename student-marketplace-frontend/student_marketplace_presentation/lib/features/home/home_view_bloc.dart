import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_view_state.dart';

class HomeViewBloc extends Cubit<HomeViewState> {
  HomeViewBloc() : super(const HomeViewState());

  void setCurrentPageIndex(int index) =>
      emit(state.copyWith(currentPageIndex: index));

  void setSearchHint(String text) {
    emit(state.copyWith(searchHint: text));
  }
}

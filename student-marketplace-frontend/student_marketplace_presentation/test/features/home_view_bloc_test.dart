import 'package:student_marketplace_presentation/core/constants/enums.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:student_marketplace_presentation/features/home/home_view_bloc.dart';
import 'package:student_marketplace_presentation/features/home/home_view_state.dart';

void main() {
  late HomeViewBloc bloc;
  late HomeViewState state;
  setUp(() {
    state = const HomeViewState();

    bloc = HomeViewBloc();
  });

  blocTest(
    'should emit a state with HomePageStatus.home when calling goToHome',
    setUp: () => state = const HomeViewState(),
    build: () => bloc,
    act: (bloc) => bloc.goToHome(),
    expect: () => [
      state.copyWith(
          status: HomePageStatus.home, title: "Discover", hasLoadedPosts: true)
    ],
  );

  blocTest(
    'should emit a state with HomePageStatus.orders when calling goToOrders',
    setUp: () => state = const HomeViewState(),
    build: () => bloc,
    act: (bloc) => bloc.goToOrders(),
    expect: () =>
        [state.copyWith(status: HomePageStatus.messages, title: 'Orders')],
  );

  blocTest(
    'should emit a state with HomePageStatus.addPost when calling goToAddPost',
    setUp: () => state = const HomeViewState(),
    build: () => bloc,
    act: (bloc) => bloc.goToAddPost(),
    expect: () =>
        [state.copyWith(status: HomePageStatus.addPost, title: 'Sell an Item')],
  );

  blocTest(
    'should emit a state with HomePageStatus.favorites when calling goToFavorites',
    setUp: () => state = const HomeViewState(),
    build: () => bloc,
    act: (bloc) => bloc.goToFavorites(),
    expect: () =>
        [state.copyWith(status: HomePageStatus.favorites, title: 'Favorites')],
  );

  blocTest(
    'should emit a state with HomePageStatus.account when calling goToAccount',
    setUp: () => state = const HomeViewState(),
    build: () => bloc,
    act: (bloc) => bloc.goToAccount(),
    expect: () =>
        [state.copyWith(status: HomePageStatus.account, title: 'Account')],
  );

  blocTest(
    'should emit a state with hint = someHint when calling goToAccount',
    setUp: () => state = const HomeViewState(),
    build: () => bloc,
    act: (bloc) => bloc.setSearchHint('someHint'),
    expect: () => [state.copyWith(searchHint: 'someHint')],
  );
}

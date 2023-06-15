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
    'should emit a state with hint = someHint when calling goToAccount',
    setUp: () => state = const HomeViewState(),
    build: () => bloc,
    act: (bloc) => bloc.setSearchHint('someHint'),
    expect: () => [state.copyWith(searchHint: 'someHint')],
  );
}

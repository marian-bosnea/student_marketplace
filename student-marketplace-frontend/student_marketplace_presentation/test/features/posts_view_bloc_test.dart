import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:student_marketplace_presentation/core/config/injection_container.dart';
import 'package:student_marketplace_presentation/features/home/home_view_bloc.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_state.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';
import 'package:test/test.dart';

import '../core/entities.mocks.dart';
import '../core/usecase.mocks.dart';

void main() {
  sl.registerLazySingleton<HomeViewBloc>(() => HomeViewBloc());

  late MockGetAllPostsUsecase getAllPostsUsecase;
  late MockGetAllCategoriesUsecase getAllCategoriesUsecase;
  late MockGetAllPostsByQueryUsecase getAllPostsByQueryUsecase;
  late MockGetAllPostsByCategoryUsecase getAllPostsByCategoryUsecase;
  late MockAddToFavoritesUsecase addToFavoritesUsecase;
  late MockRemoveFromFavoritesUsecase removeFromFavoritesUsecase;

  late PostViewBloc bloc;
  late PostViewState state;

  late List<MockProductCategoryEntity> categories;
  late List<MockSalePostEntity> posts;

  setUp(() {
    getAllPostsUsecase = MockGetAllPostsUsecase();
    getAllPostsByQueryUsecase = MockGetAllPostsByQueryUsecase();
    getAllPostsByCategoryUsecase = MockGetAllPostsByCategoryUsecase();
    addToFavoritesUsecase = MockAddToFavoritesUsecase();
    removeFromFavoritesUsecase = MockRemoveFromFavoritesUsecase();
    getAllCategoriesUsecase = MockGetAllCategoriesUsecase();

    bloc = PostViewBloc(
        getAllPostsUsecase: getAllPostsUsecase,
        getAllCategoriesUsecase: getAllCategoriesUsecase,
        getAllPostsByCategoryUsecase: getAllPostsByCategoryUsecase,
        addToFavoritesUsecase: addToFavoritesUsecase,
        removeFromFavoritesUsecase: removeFromFavoritesUsecase,
        getAllPostsByQueryUsecase: getAllPostsByQueryUsecase);

    state = const PostViewState();

    categories = [];
    categories.add(MockProductCategoryEntity());
    categories.add(MockProductCategoryEntity());

    posts = [];
    posts.add(MockSalePostEntity());
    posts.add(MockSalePostEntity());
  });

  group('Categories', () {
    test(
        'should call the getAllCategories usecase when calling fetchAllCategories',
        () async {
      // arange
      when(getAllCategoriesUsecase.call(any))
          .thenAnswer((_) async => Right(categories));
      // act
      bloc.fetchAllCategories();

      // assert
      verify(getAllCategoriesUsecase.call(any));
    });
    blocTest(
      'emits a state with categories when usecase returns a right',
      setUp: () {
        when(getAllCategoriesUsecase.call(any))
            .thenAnswer((_) async => Right(categories));
      },
      build: () => bloc,
      act: (bloc) => bloc.fetchAllCategories(),
      expect: () => [state.copyWith(categories: categories)],
    );

    blocTest(
        'should call fetchPostsOfSelectedCategory  when calling selectCategory with index != -1 ',
        setUp: () {
          when(categories[0].name).thenReturn('someName');
          when(categories[0].id).thenReturn(0);
          //when(bloc.notifyCategoryChanged()).thenReturn((realInvocation) {});
          when(getAllPostsByCategoryUsecase.call(any))
              .thenAnswer((_) async => Right(posts));
        },
        build: () => bloc,
        act: (bloc) => bloc.selectCategory(1),
        seed: () => state.copyWith(categories: categories),
        verify: (bloc) {
          verify(bloc.fetchAllPostsOfSelectedCategory());
        });
  });
}

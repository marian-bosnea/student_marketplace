import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_query_usecase.dart';
import 'package:student_marketplace_presentation/features/search_view/search_view_state.dart';

class SearchViewBloc extends Cubit<SearchViewState> {
  final GetAllPostsByQueryUsecase getAllPostsByQueryUsecase;

  SearchViewBloc({required this.getAllPostsByQueryUsecase})
      : super(SearchViewState());

  Future<void> fetchPostsPage(int page, PagingController controller) async {
    emit(state.copyWith(status: SearchViewStatus.loading));

    const elementsCount = 5;
    final offset = page * elementsCount;
    Either<Failure, List<SalePostEntity>> postsResult = const Right([]);

    postsResult = await getAllPostsByQueryUsecase(QueryParam(
        query: state.searchQuery,
        categoryId: state.selectedCategoryId,
        offset: offset,
        limit: elementsCount));

    final posts = (postsResult as Right).value;

    emit(state.copyWith(status: SearchViewStatus.loaded));

    if (state.searchQuery.isEmpty && state.selectedCategoryId == -1) {
      emit(state.copyWith(status: SearchViewStatus.intial));
      controller.itemList = <SalePostEntity>[];
      return;
    }

    if (posts.length < elementsCount) {
      controller.appendLastPage(posts);
    } else {
      controller.appendPage(posts, page + 1);
    }
  }

  setCategoryId(int categoryId) {
    if (categoryId == state.selectedCategoryId) {
      emit(state.copyWith(selectedCategoryId: -1));
      return;
    }

    emit(state.copyWith(
        selectedCategoryId: categoryId, status: SearchViewStatus.loading));
  }

  setSearchQuery(String query) {
    emit(state.copyWith(
        searchQuery: query,
        status: query.isEmpty
            ? SearchViewStatus.intial
            : SearchViewStatus.loading));
  }

  reset() {
    emit(state.copyWith(searchQuery: '', selectedCategoryId: -1));
  }
}

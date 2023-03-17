import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_query_usecase.dart';
import 'package:student_marketplace_presentation/features/search/search_view_state.dart';

import '../detailed_post/detailed_post_view_bloc.dart';

class SearchViewBloc extends Cubit<SearchViewState> {
  final GetAllPostsByQueryUsecase getAllPostsByQueryUsecase;

  late SearchViewState _state = const SearchViewState();

  SearchViewBloc({
    required this.getAllPostsByQueryUsecase,
  }) : super(const SearchViewState());

  Future<void> goToDetailedPostPage(int id, BuildContext context) async {
    BlocProvider.of<DetailedPostViewBloc>(context).setSelectedImage(0);
    Navigator.of(context).pushNamed('/detailed_post', arguments: id);
  }

  Future<void> performSearch(String query) async {
    _state = state.copyWith(status: SearchPageStatus.loading);
    emit(_state);

    final result = await getAllPostsByQueryUsecase(QueryParam(query: query));

    if (result is Left) {
      _state = _state.copyWith(status: SearchPageStatus.fail);
    } else {
      final posts = (result as Right).value;
      _state = _state.copyWith(posts: posts, status: SearchPageStatus.loaded);
    }

    emit(_state);
  }
}

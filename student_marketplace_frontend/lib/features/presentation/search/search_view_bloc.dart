import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/presentation/search/search_page_state.dart';

import '../../domain/usecases/sale_post/get_all_posts_by_query_usecase.dart';
import '../detailed_post/detailed_post_cubit.dart';

class SearchBloc extends Cubit<SearchPageState> {
  final GetAllPostsByQueryUsecase getAllPostsByQueryUsecase;

  late SearchPageState _state = SearchPageState();

  SearchBloc({
    required this.getAllPostsByQueryUsecase,
  }) : super(const SearchPageState());

  Future<void> goToDetailedPostPage(String id, BuildContext context) async {
    BlocProvider.of<DetailedPostCubit>(context).setSelectedImage(0);
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

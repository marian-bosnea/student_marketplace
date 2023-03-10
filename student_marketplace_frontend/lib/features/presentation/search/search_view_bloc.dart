import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/sale_post/get_detailed_post_usecase.dart';
import 'package:student_marketplace_frontend/features/presentation/search/search_page_state.dart';

import '../../domain/usecases/sale_post/get_all_posts_by_query_usecase.dart';
import '../detailed_post/detailed_post_cubit.dart';
import '../detailed_post/detailed_post_page.dart';

class SearchBloc extends Cubit<SearchPageState> {
  final GetAllPostsByQueryUsecase getAllPostsByQueryUsecase;
  final GetDetailedPostUsecase getDetailedPostUsecase;

  late SearchPageState _state = SearchPageState();

  SearchBloc(
      {required this.getAllPostsByQueryUsecase,
      required this.getDetailedPostUsecase})
      : super(const SearchPageState());

  Future<void> goToDetailedPostPage(String id, BuildContext context) async {
    final result = await getDetailedPostUsecase(IdParam(id: id));

    if (result is Left) return;

    final post = (result as Right).value;

    BlocProvider.of<DetailedPostCubit>(context).setSelectedImage(0);

    Navigator.of(context).push(platformPageRoute(
        context: context, builder: (context) => DetailedPostPage(post: post)));
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

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_favorite_posts_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/remove_from_favorites_usecase.dart';

import '../../core/constants/enums.dart';
import 'favorites_view_state.dart';

class FavoritesViewBloc extends Cubit<FavoritesViewState> {
  final GetFavoritePostsUsecase getFavoritePostsUsecase;
  final RemoveFromFavoritesUsecase removeFromFavoritesUsecase;

  late FavoritesViewState _state = const FavoritesViewState();

  FavoritesViewBloc(
      {required this.getFavoritePostsUsecase,
      required this.removeFromFavoritesUsecase})
      : super(const FavoritesViewState()) {
    getFavoritePosts();
  }

  Future<void> removeFromFavorites(String postId) async {
    await removeFromFavoritesUsecase(IdParam(id: postId));
    getFavoritePosts();
  }

  Future<void> goToDetailedPostPage(
      SalePostEntity post, BuildContext context) async {
    Navigator.of(context)
        .pushNamed('/detailed_post', arguments: post.postId)
        .then((value) {
      getFavoritePosts();
    });
  }

  Future<void> getFavoritePosts() async {
    _state = _state.copyWith(status: PostsViewStatus.loading);
    emit(_state);

    final results = await getFavoritePostsUsecase(NoParams());

    if (results is Left) {
      _state = _state.copyWith(status: PostsViewStatus.fail);
    } else {
      final posts = (results as Right).value;
      _state = _state.copyWith(posts: posts, status: PostsViewStatus.loaded);
    }

    emit(_state);
  }
}

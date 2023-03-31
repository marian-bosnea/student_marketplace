import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/add_to_favorites_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/check_if_favorite_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_detailed_post_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/remove_from_favorites_usecase.dart';
import 'package:student_marketplace_presentation/features/favorites/favorites_view_bloc.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';

import '../../core/constants/enums.dart';
import 'detailed_post_view_state.dart';

class DetailedPostViewBloc extends Cubit<DetailedPostViewState> {
  final AddToFavoritesUsecase addToFavoritesUsecase;
  final CheckIfFavoriteUsecase checkIfFavoriteUsecase;
  final GetDetailedPostUsecase getDetailedPostUsecase;
  final RemoveFromFavoritesUsecase removeFromFavoritesUsecase;

  DetailedPostViewBloc(
      {required this.addToFavoritesUsecase,
      required this.checkIfFavoriteUsecase,
      required this.getDetailedPostUsecase,
      required this.removeFromFavoritesUsecase})
      : super(const DetailedPostViewState());

  setSelectedImage(int index) {
    emit(state.copyWith(selectedImageIndex: index));
  }

  Future<void> checkIfFavorite(int id) async {
    final result = await checkIfFavoriteUsecase(IdParam(id: id));

    if (result is Left) {
      return;
    } else {
      final isFavorite = (result as Right).value;
      emit(state.copyWith(isFavorite: isFavorite));
    }
    emit(state);
  }

  Future<void> fetchDetailedPost(int id) async {
    emit(state.copyWith(status: PostsViewStatus.loading));

    final result = await getDetailedPostUsecase(IdParam(id: id));

    if (result is Left) {
      emit(state.copyWith(status: PostsViewStatus.fail));
    } else {
      final post = (result as Right).value;
      emit(state.copyWith(post: post, status: PostsViewStatus.loaded));
    }
    emit(state);

    checkIfFavorite(id);
  }

  Future<bool> onFavoritePressed(BuildContext context, int id) async {
    bool result = false;
    if (state.isFavorite) {
      await removeFromFavoritesUsecase(IdParam(id: id));
    } else {
      await addToFavoritesUsecase(IdParam(id: id));
      result = true;
    }
    emit(state.copyWith(isFavorite: !state.isFavorite));

    BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
    BlocProvider.of<FavoritesViewBloc>(context).fetchFavoritePosts();

    return result;
  }

  resetContext() {
    emit(const DetailedPostViewState());
  }
}

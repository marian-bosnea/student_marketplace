import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/add_to_favorites_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/check_if_favorite_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_detailed_post_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/remove_from_favorites_usecase.dart';

import '../../core/constants/enums.dart';
import 'detailed_post_state.dart';

class DetailedPostCubit extends Cubit<DetailedPostPageState> {
  final AddToFavoritesUsecase addToFavoritesUsecase;
  final CheckIfFavoriteUsecase checkIfFavoriteUsecase;
  final GetDetailedPostUsecase getDetailedPostUsecase;
  final RemoveFromFavoritesUsecase removeFromFavoritesUsecase;
  DetailedPostPageState _state = const DetailedPostPageState();

  DetailedPostCubit(
      {required this.addToFavoritesUsecase,
      required this.checkIfFavoriteUsecase,
      required this.getDetailedPostUsecase,
      required this.removeFromFavoritesUsecase})
      : super(const DetailedPostPageState());

  setSelectedImage(int index) {
    _state = _state.copyWith(selectedImageIndex: index);
    emit(_state);
  }

  Future<void> checkIfFavorite(String id) async {
    final result = await checkIfFavoriteUsecase(IdParam(id: id));

    if (result is Left) {
      return;
    } else {
      final isFavorite = (result as Right).value;
      _state = _state.copyWith(isFavorite: isFavorite);
    }
    emit(state);
  }

  Future<void> fetchDetailedPost(String id) async {
    _state = _state.copyWith(status: PostsViewStatus.loading);
    emit(_state);

    final result = await getDetailedPostUsecase(IdParam(id: id));

    if (result is Left) {
      _state = _state.copyWith(status: PostsViewStatus.fail);
    } else {
      final post = (result as Right).value;
      _state = _state.copyWith(post: post, status: PostsViewStatus.loaded);
    }
    emit(_state);
  }

  Future<bool> onFavoritePressed(String id) async {
    bool result = false;
    if (_state.isFavorite) {
      await removeFromFavoritesUsecase(IdParam(id: id));
    } else {
      await addToFavoritesUsecase(IdParam(id: id));
      result = true;
    }
    _state = _state.copyWith(isFavorite: !_state.isFavorite);
    emit(_state);

    return result;
  }

  resetContext() {
    _state = const DetailedPostPageState();
  }
}

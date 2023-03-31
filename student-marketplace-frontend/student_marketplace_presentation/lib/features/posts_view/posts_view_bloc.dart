import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/product_category_model.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/get_cached_session_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/product_category/get_all_categories_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/add_to_favorites_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_category_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_query_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_detailed_post_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/remove_from_favorites_usecase.dart';
import 'package:student_marketplace_presentation/features/home/home_view_bloc.dart';

import '../../core/constants/enums.dart';
import '../detailed_post/detailed_post_view_bloc.dart';
import 'posts_state.dart';

class PostViewBloc extends Cubit<PostViewState> {
  final GetAllPostsUsecase getAllPostsUsecase;
  final GetAllPostsByCategory getAllPostsByCategoryUsecase;
  final GetAllCategoriesUsecase getAllCategoriesUsecase;
  final GetCachedSessionUsecase getCachedSessionUsecase;
  final GetDetailedPostUsecase getDetailedPostUsecase;
  final AddToFavoritesUsecase addToFavoritesUsecase;
  final GetAllPostsByQueryUsecase getAllPostsByQueryUsecase;
  final RemoveFromFavoritesUsecase removeFromFavoritesUsecase;

  PostViewBloc(
      {required this.getAllPostsUsecase,
      required this.getCachedSessionUsecase,
      required this.getAllCategoriesUsecase,
      required this.getDetailedPostUsecase,
      required this.getAllPostsByCategoryUsecase,
      required this.addToFavoritesUsecase,
      required this.removeFromFavoritesUsecase,
      required this.getAllPostsByQueryUsecase})
      : super(const PostViewState());

  Future<void> fetchAllCategories() async {
    final categoriesResult = await getAllCategoriesUsecase(NoParams());
    if (categoriesResult is Left) {
    } else {
      final categories = (categoriesResult as Right).value;
      emit(state.copyWith(categories: categories));
    }

    emit(state);
  }

  Future<void> selectCategory(int index) async {
    if (index != state.selectedCategoryIndex) {
      emit(state.copyWith(selectedCategoryIndex: index));

      if (index != -1) {
        await fetchAllPostsOfSelectedCategory();
      } else {
        fetchAllPosts();
      }
    }
  }

  Future<void> fetchAllPostsOfSelectedCategory() async {
    emit(state.copyWith(status: PostsViewStatus.loading));

    final postsResult = await getAllPostsByCategoryUsecase(CategoryParam(
        categoryId: state.categories[state.selectedCategoryIndex - 1].id));

    if (postsResult is Left) {
      emit(state.copyWith(status: PostsViewStatus.fail));
    } else {
      final posts = (postsResult as Right).value;
      emit(state.copyWith(status: PostsViewStatus.loaded, posts: posts));
    }
    _getFeaturedItem();

    emit(state);
  }

  Future<void> fetchAllPostsByTextQuery(String query) async {
    onSearchQueryChanged(query);
    emit(state.copyWith(status: PostsViewStatus.loading));

    final result = await getAllPostsByQueryUsecase(QueryParam(query: query));

    if (result is Left) {
      emit(state.copyWith(status: PostsViewStatus.fail));
    } else {
      final posts = (result as Right).value;
      if (state.selectedCategoryIndex != -1) {
        List<SalePostEntity> filteredPosts = [];
        final selectedCategoryId =
            state.categories[state.selectedCategoryIndex - 1].id;
        for (var p in posts) {
          if (p.categoryId == selectedCategoryId) {
            filteredPosts.add(p);
          }
        }
        emit(state.copyWith(
            posts: filteredPosts, status: PostsViewStatus.loaded));
      } else {
        emit(state.copyWith(posts: posts, status: PostsViewStatus.loaded));
      }
    }
  }

  Future<void> onSearchQueryChanged(String query) async {
    if (query.isEmpty) {
      if (state.selectedCategoryIndex == -1) {
        fetchAllPosts();
      } else {
        fetchAllPostsOfSelectedCategory();
      }
    }
  }

  Future<void> fetchAllPosts() async {
    emit(state.copyWith(status: PostsViewStatus.loading));

    final postsResult = await getAllPostsUsecase(NoParams());
    if (postsResult is Left) {
      emit(state.copyWith(status: PostsViewStatus.fail));
    } else {
      final posts = (postsResult as Right).value;
      emit(state.copyWith(status: PostsViewStatus.loaded, posts: posts));

      _getFeaturedItem();
    }
  }

  Future<bool> onFavoriteButtonPressed(
      BuildContext context, SalePostEntity post, bool isFavorite) async {
    if (isFavorite) {
      removeFromFavoritesUsecase(IdParam(id: post.postId!));
    } else {
      addToFavoritesUsecase(IdParam(id: post.postId!));
    }
    BlocProvider.of<HomeViewBloc>(context).notifyPostItemChanged(context);

    return !isFavorite;
  }

  _getFeaturedItem() {
    SalePostEntity item = state.posts.first;
    int maxViewCount = 0;

    for (var element in state.posts) {
      maxViewCount = max(maxViewCount, element.viewsCount!);
      if (maxViewCount == element.viewsCount) {
        item = element;
      }
    }

    emit(state.copyWith(featuredPost: item));
  }
}

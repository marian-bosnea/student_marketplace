import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/get_cached_session_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/product_category/get_all_categories_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_category_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_detailed_post_usecase.dart';

import '../../core/constants/enums.dart';
import '../detailed_post/detailed_post_view_bloc.dart';
import 'posts_state.dart';

class PostViewCubit extends Cubit<PostViewState> {
  final GetAllPostsUsecase getAllPostsUsecase;
  final GetAllPostsByCategory getAllPostsByCategoryUsecase;
  final GetAllCategoriesUsecase getAllCategoriesUsecase;
  final GetCachedSessionUsecase getCachedSessionUsecase;
  final GetDetailedPostUsecase getDetailedPostUsecase;

  PostViewCubit(
      {required this.getAllPostsUsecase,
      required this.getCachedSessionUsecase,
      required this.getAllCategoriesUsecase,
      required this.getDetailedPostUsecase,
      required this.getAllPostsByCategoryUsecase})
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
    emit(state.copyWith(selectedCategoryIndex: index));
    emit(state);

    if (index != -1) {
      await fetchAllPostsOfSelectedCategory();
    } else {
      fetchAllPosts();
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

  Future<void> goToDetailedPostPage(int id, BuildContext context) async {
    BlocProvider.of<DetailedPostViewBloc>(context).setSelectedImage(0);

    Navigator.of(context).pushNamed('/detailed_post', arguments: id);
  }

  Future<void> fetchAllPosts() async {
    emit(state.copyWith(status: PostsViewStatus.loading));

    final postsResult = await getAllPostsUsecase(NoParams());
    if (postsResult is Left) {
      emit(state.copyWith(status: PostsViewStatus.fail));
    } else {
      final posts = (postsResult as Right).value;
      emit(state.copyWith(status: PostsViewStatus.loaded, posts: posts));
    }

    _getFeaturedItem();

    emit(state);
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

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/data/models/auth_session_model.dart';
import 'package:student_marketplace_frontend/features/domain/entities/product_category_entity.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/get_cached_session_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/product_category/get_all_categories_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/sale_post/get_all_posts_by_category_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/sale_post/get_all_posts_usecase.dart';
import 'package:student_marketplace_frontend/features/presentation/posts_view/post_view_state.dart';

class PostViewCubit extends Cubit<PostViewState> {
  final GetAllPostsUsecase getAllPostsUsecase;
  final GetAllPostsByCategory getAllPostsByCategoryUsecase;
  final GetAllCategoriesUsecase getAllCategoriesUsecase;
  final GetCachedSessionUsecase getCachedSessionUsecase;

  late PostViewState state = PostViewState();

  PostViewCubit(
      {required this.getAllPostsUsecase,
      required this.getCachedSessionUsecase,
      required this.getAllCategoriesUsecase,
      required this.getAllPostsByCategoryUsecase})
      : super(const PostViewState());

  Future<void> fetchAllCategories() async {
    final categoriesResult = await getAllCategoriesUsecase(NoParams());
    if (categoriesResult is Left) {
    } else {
      final categories = (categoriesResult as Right).value;
      state = state.copyWith(categories: categories);
    }

    emit(state);
  }

  Future<void> selectCategory(int index) async {
    state = state.copyWith(selectedCategoryIndex: index);
    emit(state);

    if (index != -1) {
      await fetchAllPostsOfSelectedCategory();
    } else {
      fetchAllPosts();
    }
  }

  Future<void> fetchAllPostsOfSelectedCategory() async {
    state = state.copyWith(status: PostsViewStatus.loading);
    emit(state);

    final postsResult = await getAllPostsByCategoryUsecase(CategoryParam(
        categoryId:
            state.categories[state.selectedCategoryIndex - 1].id.toString()));

    if (postsResult is Left) {
      state = state.copyWith(status: PostsViewStatus.fail);
    } else {
      final posts = (postsResult as Right).value;
      state = state.copyWith(status: PostsViewStatus.loaded, posts: posts);
    }

    emit(state);
  }

  Future<void> fetchAllPosts() async {
    state = state.copyWith(status: PostsViewStatus.loading);
    emit(state);

    final postsResult = await getAllPostsUsecase(NoParams());
    if (postsResult is Left) {
      state = state.copyWith(status: PostsViewStatus.fail);
    } else {
      final posts = (postsResult as Right).value;
      state = state.copyWith(status: PostsViewStatus.loaded, posts: posts);
    }

    emit(state);
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/sale_post/get_all_posts_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/user/get_auth_token_usecase.dart';
import 'package:student_marketplace_frontend/features/presentation/posts_view/post_view_state.dart';

class PostViewCubit extends Cubit<PostViewState> {
  final GetAllPostsUsecase getAllPostsUsecase;
  final GetAuthTokenUsecase getAuthTokenUsecase;

  late PostViewState state = PostViewState();

  PostViewCubit(
      {required this.getAllPostsUsecase, required this.getAuthTokenUsecase})
      : super(PostViewState());

  Future<void> fetchAllPosts() async {
    final result = await getAuthTokenUsecase(NoParams());
    if (result is Right) {
      final token = result.getOrElse(() => '');
      final eitherPosts = await getAllPostsUsecase(TokenParam(token: token));
      if (eitherPosts is Right) {
        final posts = eitherPosts.getOrElse(() => []);
        state = state.copyWith(status: PostsViewStatus.loaded, posts: posts);
        emit(state);
      } else {
        emit(state.copyWith(status: PostsViewStatus.fail));
      }
    } else {}
  }
}

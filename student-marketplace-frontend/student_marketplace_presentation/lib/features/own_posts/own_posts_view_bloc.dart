import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/get_all_posts_by_owner_usecase.dart';
import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_state.dart';

class OwnPostsViewBloc extends Cubit<OwnPostsViewState> {
  final GetAllPostsByOwnerUsecase getAllPostsByOwnerUsecase;

  OwnPostsViewBloc({required this.getAllPostsByOwnerUsecase})
      : super(const OwnPostsViewState());

  Future<void> fetchOwnPosts() async {
    //final result = getAllPostsByOwnerUsecase(IdParam());
  }
}

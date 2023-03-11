import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/auth_session_repository.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsUsecase extends Usecase<List<SalePostEntity>, NoParams> {
  final SalePostRepository postRepository;
  final AuthSessionRepository authRepository;
  GetAllPostsUsecase(
      {required this.postRepository, required this.authRepository});

  @override
  Future<Either<Failure, List<SalePostEntity>>> call(NoParams params) async {
    final result = await authRepository.getCachedSession();
    if (result is Left) return Left(UnauthenticatedFailure());

    final session = (result as Right).value;
    final postsResult = await postRepository.getAllPosts(session.token);

    if (postsResult is Left) return Left(NetworkFailure());
    final posts = (postsResult as Right).value;

    return Right(posts);
  }
}

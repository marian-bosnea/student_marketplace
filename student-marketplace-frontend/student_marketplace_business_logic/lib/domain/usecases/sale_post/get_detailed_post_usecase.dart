import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/auth_session_repository.dart';
import '../../repositories/sale_post_repository.dart';

class GetDetailedPostUsecase extends Usecase<SalePostEntity, IdParam> {
  final SalePostRepository postRepository;
  final AuthSessionRepository authRepository;
  GetDetailedPostUsecase(
      {required this.postRepository, required this.authRepository});

  @override
  Future<Either<Failure, SalePostEntity>> call(IdParam params) async {
    final result = await authRepository.getCachedSession();
    if (result is Left) return Left(UnauthenticatedFailure());

    final session = (result as Right).value;
    final postsResult =
        await postRepository.getDetailedPost(session.token, params.id);

    if (postsResult is Left) return Left(NetworkFailure());
    final posts = (postsResult as Right).value;

    return Right(posts);
  }
}

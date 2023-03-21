import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/auth_session_repository.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsByOwnerUsecase
    implements Usecase<List<SalePostEntity>, OptionalIdParam> {
  final SalePostRepository postRepository;
  final AuthSessionRepository authRepository;

  GetAllPostsByOwnerUsecase(
      {required this.authRepository, required this.postRepository});

  @override
  Future<Either<Failure, List<SalePostEntity>>> call(
      OptionalIdParam params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;
    final result =
        await postRepository.getAllPostsByOwner(token.token, params.id);

    if (result is Left) return Left(NetworkFailure());
    final posts = (result as Right).value;

    return Right(posts);
  }
}

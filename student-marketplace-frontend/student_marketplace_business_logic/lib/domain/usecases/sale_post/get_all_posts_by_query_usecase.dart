import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/auth_session_repository.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsByQueryUsecase
    implements Usecase<List<SalePostEntity>, QueryParam> {
  final SalePostRepository postRepository;
  final AuthSessionRepository authRepository;

  GetAllPostsByQueryUsecase(
      {required this.postRepository, required this.authRepository});

  @override
  Future<Either<Failure, List<SalePostEntity>>> call(QueryParam params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;
    final result =
        await postRepository.getPostsByQuery(token.token, params.query);

    if (result is Left) return Left(NetworkFailure());
    final posts = (result as Right).value;

    return Right(posts);
  }
}

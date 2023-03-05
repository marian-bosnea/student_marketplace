import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/auth_session_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsByCategory
    implements Usecase<List<SalePostEntity>, CategoryParam> {
  final SalePostRepository postRepository;
  final AuthSessionRepository authRepository;

  GetAllPostsByCategory(
      {required this.postRepository, required this.authRepository});

  @override
  Future<Either<Failure, List<SalePostEntity>>> call(
      CategoryParam params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;
    final result = await postRepository.getAllPostsByCategory(
        token.token, params.categoryId);

    if (result is Left) return Left(NetworkFailure());
    final posts = (result as Right).value;

    return Right(posts);
  }
}

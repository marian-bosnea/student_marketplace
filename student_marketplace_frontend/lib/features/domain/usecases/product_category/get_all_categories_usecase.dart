import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/domain/entities/product_category_entity.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/product_category_repository.dart';

import '../../repositories/auth_session_repository.dart';

class GetAllCategoriesUsecase
    extends Usecase<List<ProductCategoryEntity>, NoParams> {
  final ProductCategoryRepository categoryRepository;
  final AuthSessionRepository authRepository;

  GetAllCategoriesUsecase(
      {required this.authRepository, required this.categoryRepository});

  @override
  Future<Either<Failure, List<ProductCategoryEntity>>> call(
      NoParams params) async {
    final result = await authRepository.getCachedSession();
    if (result is Left) return Left(UnauthenticatedFailure());

    final session = (result as Right).value;
    final postsResult =
        await categoryRepository.fetchAllCategories(session.token);

    if (postsResult is Left) return Left(NetworkFailure());
    final posts = (postsResult as Right).value;

    return Right(posts);
  }
}

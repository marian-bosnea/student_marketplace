import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/product_category_entity.dart';
import '../../repositories/auth_session_repository.dart';
import '../../repositories/product_category_repository.dart';

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

import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/domain/operations/sale_post_operations.dart';

import '../../repositories/auth_session_repository.dart';

class AddToFavoritesUsecase extends Usecase<bool, IdParam> {
  final AuthSessionRepository authRepository;
  final SalePostOperations salePostOperations;

  AddToFavoritesUsecase(
      {required this.authRepository, required this.salePostOperations});

  @override
  Future<Either<Failure, bool>> call(IdParam params) async {
    final result = await authRepository.getCachedSession();
    if (result is Left) return Left(UnauthenticatedFailure());

    final session = (result as Right).value;
    final success =
        await salePostOperations.addToFavorites(params.id, session.token);

    if (success is Left) return Left(NetworkFailure());
    final successValue = (success as Right).value;

    return Right(successValue);
  }
}

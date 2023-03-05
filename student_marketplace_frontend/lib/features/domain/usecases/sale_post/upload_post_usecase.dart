import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/data/repositories/auth_repository_impl.dart';
import 'package:student_marketplace_frontend/features/domain/operations/sale_post_operations.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/auth_session_repository.dart';

import '../../../../core/error/failures.dart';
import '../../repositories/sale_post_repository.dart';

class UploadPostUsecase extends Usecase<bool, PostParam> {
  final AuthSessionRepository authRepository;
  final SalePostOperations salePostOperations;

  UploadPostUsecase(
      {required this.authRepository, required this.salePostOperations});

  @override
  Future<Either<Failure, bool>> call(PostParam params) async {
    final result = await authRepository.getCachedSession();
    if (result is Left) return Left(UnauthenticatedFailure());

    final session = (result as Right).value;
    final success = await salePostOperations.upload(params.post, session.token);

    if (success is Left) return Left(NetworkFailure());
    final successValue = (success as Right).value;

    return Right(successValue);
  }
}

import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/operations/sale_post_operations.dart';

import '../../repositories/auth_session_repository.dart';

class UpdatePostUsecase extends Usecase<bool, PostParam> {
  final SalePostOperations operations;
  final AuthSessionRepository authRepository;

  UpdatePostUsecase({required this.operations, required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(PostParam params) async {
    final result = await authRepository.getCachedSession();
    if (result is Left) return Left(UnauthenticatedFailure());

    final session = (result as Right).value;
    final success = await operations.update(params.post, session.token);

    if (success is Left) return Left(NetworkFailure());
    final successValue = (success as Right).value;

    return Right(successValue);
  }
}

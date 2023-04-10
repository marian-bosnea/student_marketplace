import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/operations/order_operations.dart';

import '../../repositories/auth_session_repository.dart';

class DeleteOrderUsecase extends Usecase<bool, OrderParam> {
  final AuthSessionRepository authRepository;
  final OrderOperations orderOperations;

  DeleteOrderUsecase(
      {required this.authRepository, required this.orderOperations});

  @override
  Future<Either<Failure, bool>> call(OrderParam params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;

    final result = orderOperations.delete(token.token, params.order);
    if (result is Left) return Left(NetworkFailure());

    return result;
  }
}

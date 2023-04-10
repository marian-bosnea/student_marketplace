import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_business_logic/domain/repositories/order_repository.dart';

import '../../repositories/auth_session_repository.dart';

class GetOrdersByBuyerUsecase extends Usecase<List<OrderEntity>, NoParams> {
  final AuthSessionRepository authRepository;
  final OrderRepository orderRepository;

  GetOrdersByBuyerUsecase(
      {required this.authRepository, required this.orderRepository});

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;

    final result = await orderRepository.getAllByBuyer(token.token);
    if (result is Left) return Left(NetworkFailure());

    return result;
  }
}

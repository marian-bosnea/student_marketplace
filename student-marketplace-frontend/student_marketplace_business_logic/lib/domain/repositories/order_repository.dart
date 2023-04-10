import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';

import '../../core/error/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getAllByBuyer(String token);
  Future<Either<Failure, List<OrderEntity>>> getAllBySeller(String token);
}

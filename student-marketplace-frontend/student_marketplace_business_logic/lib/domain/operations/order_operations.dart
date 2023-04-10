import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';

import '../../core/error/failures.dart';

abstract class OrderOperations {
  Future<Either<Failure, bool>> create(String token, OrderEntity order);
  Future<Either<Failure, bool>> update(String token, OrderEntity order);
  Future<Either<Failure, bool>> delete(String token, OrderEntity order);
}

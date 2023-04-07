import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

import '../../core/error/failures.dart';

abstract class AddressOperations {
  Future<Either<Failure, bool>> create(String token, AddressEntity address);
  Future<Either<Failure, bool>> update(String token, AddressEntity address);
  Future<Either<Failure, bool>> delete(String token, AddressEntity address);
}

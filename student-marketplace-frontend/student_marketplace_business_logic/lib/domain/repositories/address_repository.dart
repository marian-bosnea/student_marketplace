import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

import '../../core/error/failures.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> read(String token);
}

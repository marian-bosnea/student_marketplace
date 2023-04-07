import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/address_entity.dart';

abstract class AddressRemoteDataSource {
  Future<Either<Failure, bool>> create(String token, AddressEntity address);
  Future<Either<Failure, List<AddressEntity>>> read(String token);
  Future<Either<Failure, bool>> update(String token, AddressEntity address);
  Future<Either<Failure, bool>> delete(String token, AddressEntity address);
}

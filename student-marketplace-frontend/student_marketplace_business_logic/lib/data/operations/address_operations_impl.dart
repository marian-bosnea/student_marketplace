import 'package:student_marketplace_business_logic/data/data_sources/contracts/address_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/operations/address_operations.dart';

class AddressOperationsImpl extends AddressOperations {
  final AddressRemoteDataSource remoteDataSource;

  AddressOperationsImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> create(String token, AddressEntity address) =>
      remoteDataSource.create(token, address);

  @override
  Future<Either<Failure, bool>> delete(String token, AddressEntity address) =>
      remoteDataSource.delete(token, address);

  @override
  Future<Either<Failure, bool>> update(String token, AddressEntity address) =>
      remoteDataSource.update(token, address);
}

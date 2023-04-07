import 'package:student_marketplace_business_logic/core/services/http_interface.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

import 'package:student_marketplace_business_logic/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../contracts/address_remote_data_source.dart';

class AddressRemoteDataSourceImpl extends AddressRemoteDataSource {
  final HttpInterface http = HttpInterface();

  @override
  Future<Either<Failure, bool>> create(
      String token, AddressEntity address) async {
    try {
      final result = await http.createAddress(token: token, address: address);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> read(String token) async {
    try {
      final result = await http.readAddresses(token: token);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(
      String token, AddressEntity address) async {
    try {
      final result = await http.updateAddress(token: token, address: address);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(
      String token, AddressEntity address) async {
    try {
      final result = await http.deleteAddress(token: token, address: address);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }
}

import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/core/services/http_interface.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/order_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

class OrderRemoteDataSourceImpl extends OrderRemoteDataSource {
  final HttpInterface http = HttpInterface();

  @override
  Future<Either<Failure, bool>> create(String token, OrderEntity order) async {
    try {
      final result = await http.createOrder(token: token, order: order);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllByBuyer(String token) async {
    try {
      final result = await http.readOrderByBuyer(token: token);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllBySeller(
      String token) async {
    try {
      final result = await http.readOrderBySeller(token: token);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(String token, OrderEntity order) async {
    try {
      final result = await http.updateOrder(token: token, order: order);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String token, OrderEntity order) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}

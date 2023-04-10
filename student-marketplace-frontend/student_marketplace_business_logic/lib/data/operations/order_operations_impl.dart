import 'package:http/http.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/order_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/operations/order_operations.dart';

class OrderOperationsImpl extends OrderOperations {
  final OrderRemoteDataSource remoteDataSource;

  OrderOperationsImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> create(String token, OrderEntity order) =>
      remoteDataSource.create(token, order);

  @override
  Future<Either<Failure, bool>> delete(String token, OrderEntity order) =>
      remoteDataSource.delete(token, order);

  @override
  Future<Either<Failure, bool>> update(String token, OrderEntity order) =>
      remoteDataSource.update(token, order);
}

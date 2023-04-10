import 'package:student_marketplace_business_logic/data/data_sources/contracts/order_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';
import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/repositories/order_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllByBuyer(
          String token) async =>
      remoteDataSource.getAllByBuyer(token);

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllBySeller(String token) =>
      remoteDataSource.getAllBySeller(token);
}

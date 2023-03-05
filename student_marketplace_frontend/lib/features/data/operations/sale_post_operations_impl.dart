import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/sale_post_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/domain/operations/sale_post_operations.dart';

import '../../domain/entities/sale_post_entity.dart';

class SalePostOperationsImpl extends SalePostOperations {
  final SalePostRemoteDataSource remoteDataSource;

  SalePostOperationsImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> update(
      SalePostEntity post, String token) async {
    return await remoteDataSource.update(post, token);
  }

  @override
  Future<Either<Failure, bool>> upload(
      SalePostEntity post, String token) async {
    return await remoteDataSource.upload(post, token);
  }
}

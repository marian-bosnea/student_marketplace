import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/sale_post_entity.dart';
import '../../domain/operations/sale_post_operations.dart';
import '../data_sources/contracts/sale_post_remote_data_source.dart';

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

  @override
  Future<Either<Failure, bool>> addToFavorites(
      String postId, String token) async {
    return await remoteDataSource.addToFavorites(postId, token);
  }

  @override
  Future<Either<Failure, bool>> checkIfFavorite(
      String postId, String token) async {
    return await remoteDataSource.checkIfFavorite(postId, token);
  }

  @override
  Future<Either<Failure, bool>> removeFromFavorites(
      String postId, String token) async {
    return await remoteDataSource.removeFromFavorites(postId, token);
  }
}

import '../data_sources/contracts/sale_post_remote_data_source.dart';
import '../../domain/entities/sale_post_entity.dart';
import '../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/sale_post_repository.dart';

class SalePostRepositoryImpl implements SalePostRepository {
  final SalePostRemoteDataSource remoteDataSource;

  SalePostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPosts(
          String token) async =>
      remoteDataSource.getAllPosts(token);

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
          String token, String categoryId) async =>
      remoteDataSource.getAllPostsByCategory(token, categoryId);

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
          String token, String ownerId) async =>
      remoteDataSource.getAllPostsByOwner(token, ownerId);

  @override
  Future<Either<Failure, SalePostEntity>> getDetailedPost(
          String token, String postId) async =>
      remoteDataSource.getDetailedPost(token, postId);
}

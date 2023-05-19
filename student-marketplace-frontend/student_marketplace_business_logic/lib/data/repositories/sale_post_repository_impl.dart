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
          String token, int limit, int offset) async =>
      remoteDataSource.getAllPosts(token, limit, offset);

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
          {required String token,
          required int categoryId,
          required int offset,
          required int limit}) async =>
      remoteDataSource.getAllPostsByCategory(
          token: token, categoryId: categoryId, limit: limit, offset: offset);

  @override
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
          String token, int? ownerId) async =>
      remoteDataSource.getAllPostsByOwner(token, ownerId);

  @override
  Future<Either<Failure, SalePostEntity>> getDetailedPost(
          String token, int postId) async =>
      remoteDataSource.getDetailedPost(token, postId);

  @override
  Future<Either<Failure, List<SalePostEntity>>> getPostsByQuery(
          {required String token,
          required String query,
          required int categoryId,
          required int offset,
          required int limit}) async =>
      remoteDataSource.getAllPostsByQuery(
          token: token,
          query: query,
          categoryId: categoryId,
          limit: limit,
          offset: offset);

  @override
  Future<Either<Failure, List<SalePostEntity>>> getFavoritePosts(
          String token) async =>
      remoteDataSource.getFavoritesPosts(token);
}

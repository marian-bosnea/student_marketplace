import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/sale_post_entity.dart';

abstract class SalePostRemoteDataSource {
  Future<Either<Failure, SalePostEntity>> getDetailedPost(
      String token, int postId);

  Future<Either<Failure, List<SalePostEntity>>> getAllPosts(
      String token, int limit, int offset);
  Future<Either<Failure, List<SalePostEntity>>> getFavoritesPosts(String token);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByQuery(
      String token, String query);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      {required String token,
      required int categoryId,
      required int offset,
      required int limit});

  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String token, int? ownerId);

  Future<Either<Failure, bool>> addToFavorites(int postId, String token);
  Future<Either<Failure, bool>> removeFromFavorites(int postId, String token);
  Future<Either<Failure, bool>> checkIfFavorite(int postId, String token);

  Future<Either<Failure, bool>> upload(SalePostEntity post, String token);
  Future<Either<Failure, bool>> update(SalePostEntity post, String token);
}

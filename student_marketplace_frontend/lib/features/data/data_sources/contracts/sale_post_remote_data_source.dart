import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/sale_post/get_detailed_post_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/sale_post_entity.dart';

abstract class SalePostRemoteDataSource {
  Future<Either<Failure, SalePostEntity>> getDetailedPost(
      String token, String postId);

  Future<Either<Failure, List<SalePostEntity>>> getAllPosts(String token);
  Future<Either<Failure, List<SalePostEntity>>> getFavoritesPosts(String token);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByQuery(
      String token, String query);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      String token, String categoryId);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String token, String ownerId);

  Future<Either<Failure, bool>> addToFavorites(String postId, String token);
  Future<Either<Failure, bool>> removeFromFavorites(
      String postId, String token);
  Future<Either<Failure, bool>> checkIfFavorite(String postId, String token);

  Future<Either<Failure, bool>> upload(SalePostEntity post, String token);
  Future<Either<Failure, bool>> update(SalePostEntity post, String token);
}

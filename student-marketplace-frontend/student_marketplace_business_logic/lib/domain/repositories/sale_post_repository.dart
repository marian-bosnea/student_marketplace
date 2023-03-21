import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/sale_post_entity.dart';

abstract class SalePostRepository {
  Future<Either<Failure, SalePostEntity>> getDetailedPost(
      String token, int postId);

  Future<Either<Failure, List<SalePostEntity>>> getAllPosts(String token);
  Future<Either<Failure, List<SalePostEntity>>> getFavoritePosts(String token);

  Future<Either<Failure, List<SalePostEntity>>> getPostsByQuery(
      String token, String query);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      String token, int categoryId);

  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String token, int? ownerId);
}

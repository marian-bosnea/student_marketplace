import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/sale_post_entity.dart';

abstract class SalePostRepository {
  Future<Either<Failure, SalePostEntity>> getDetailedPost(
      String token, int postId);

  Future<Either<Failure, List<SalePostEntity>>> getAllPosts(
      String token, int limit, int offset);
  Future<Either<Failure, List<SalePostEntity>>> getFavoritePosts(String token);

  Future<Either<Failure, List<SalePostEntity>>> getPostsByQuery(
      {required String token,
      required String query,
      required int categoryId,
      required int offset,
      required int limit});

  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      {required String token,
      required int categoryId,
      required int offset,
      required int limit});

  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String token, int? ownerId);
}

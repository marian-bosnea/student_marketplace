import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/sale_post_entity.dart';

abstract class SalePostRepository {
  Future<Either<Failure, List<SalePostEntity>>> getAllPosts(String token);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      String token, String categoryId);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String token, String ownerId);
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/sale_post_entity.dart';

abstract class SalePostRemoteDataSource {
  Future<Either<Failure, List<SalePostEntity>>> getAllPosts(String token);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      String token, String categoryId);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String token, String ownerId);
}

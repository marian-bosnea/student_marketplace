import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/sale_post_entity.dart';

abstract class SalePostRemoteDataSource {
  Future<Either<Failure, List<SalePostEntity>>> getAllPosts();
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByCategory(
      String categoryId);
  Future<Either<Failure, List<SalePostEntity>>> getAllPostsByOwner(
      String ownerId);
}

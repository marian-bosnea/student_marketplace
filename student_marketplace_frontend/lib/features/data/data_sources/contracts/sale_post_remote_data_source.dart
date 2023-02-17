import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/sale_post_entity.dart';

abstract class SalePostRemoteDataSource {
  Future<Either<Failure, List<SalePost>>> getAllPosts();
  Future<Either<Failure, List<SalePost>>> getAllPostsByCategory(
      String categoryId);
  Future<Either<Failure, List<SalePost>>> getAllPostsByOwner(String ownerId);
}

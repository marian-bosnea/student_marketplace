import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/sale_post_entity.dart';

abstract class SalePostOperations {
  Future<Either<Failure, bool>> upload(SalePostEntity post, String token);
  Future<Either<Failure, bool>> update(SalePostEntity post, String token);

  Future<Either<Failure, bool>> addToFavorites(String postId, String token);

  Future<Either<Failure, bool>> checkIfFavorite(String postId, String token);
  Future<Either<Failure, bool>> removeFromFavorites(
      String postId, String token);
}

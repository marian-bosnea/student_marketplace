import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';

abstract class SalePostRepository {
  Future<Either<Failure, bool>> publishPost();
  Future<Either<Failure, bool>> updatePost();
  Future<Either<Failure, bool>> deletePost();
}

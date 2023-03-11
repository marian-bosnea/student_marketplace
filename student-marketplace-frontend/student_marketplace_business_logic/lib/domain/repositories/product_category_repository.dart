import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/product_category_entity.dart';

abstract class ProductCategoryRepository {
  Future<Either<Failure, List<ProductCategoryEntity>>> fetchAllCategories(
      String token);
}

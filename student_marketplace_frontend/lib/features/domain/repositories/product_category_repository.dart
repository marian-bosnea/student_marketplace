import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/entities/product_category_entity.dart';

import '../../../core/error/failures.dart';

abstract class ProductCategoryRepository {
  Future<Either<Failure, List<ProductCategoryEntity>>> fetchAllCategories(
      String token);
}

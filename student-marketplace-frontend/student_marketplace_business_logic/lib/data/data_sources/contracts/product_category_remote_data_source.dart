import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/product_category_entity.dart';

abstract class ProductCategoryRemoteDataSource {
  Future<Either<Failure, List<ProductCategoryEntity>>> fetchAllCategories(
      String token);
}

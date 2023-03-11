import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/services/http_interface.dart';
import '../../../domain/entities/product_category_entity.dart';
import '../contracts/product_category_remote_data_source.dart';

class ProductCategoryRemoteDataSourceImpl
    extends ProductCategoryRemoteDataSource {
  HttpInterface http = HttpInterface();

  @override
  Future<Either<Failure, List<ProductCategoryEntity>>> fetchAllCategories(
      String token) async {
    final results = await http.fetchAllCategories(token);

    return Right(results);
  }
}

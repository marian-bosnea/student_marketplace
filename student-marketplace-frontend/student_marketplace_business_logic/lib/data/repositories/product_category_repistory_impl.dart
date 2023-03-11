import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/product_category_entity.dart';
import '../../domain/repositories/product_category_repository.dart';
import '../data_sources/contracts/product_category_remote_data_source.dart';

class ProductCategoryRepositoryImpl extends ProductCategoryRepository {
  final ProductCategoryRemoteDataSource remoteDataSource;

  ProductCategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductCategoryEntity>>> fetchAllCategories(
          String token) async =>
      remoteDataSource.fetchAllCategories(token);
}

import 'package:student_marketplace_frontend/features/data/data_sources/contracts/product_category_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/domain/entities/product_category_entity.dart';
import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/product_category_repository.dart';

class ProductCategoryRepositoryImpl extends ProductCategoryRepository {
  final ProductCategoryRemoteDataSource remoteDataSource;

  ProductCategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductCategoryEntity>>> fetchAllCategories(
          String token) async =>
      remoteDataSource.fetchAllCategories(token);
}

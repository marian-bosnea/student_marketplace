import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsByCategory
    implements Usecase<List<SalePostEntity>, CategoryParam> {
  final SalePostRepository repository;

  GetAllPostsByCategory({required this.repository});

  @override
  Future<Either<Failure, List<SalePostEntity>>> call(CategoryParam params) {
    return repository.getAllPostsByCategory(params.token, params.categoryId);
  }
}

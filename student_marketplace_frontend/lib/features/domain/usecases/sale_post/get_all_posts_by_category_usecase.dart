import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/sale_post_repository.dart';

class GetAllPostsByCategory implements Usecase<List<SalePost>, IdParam> {
  final SalePostRepository repository;

  GetAllPostsByCategory({required this.repository});

  @override
  Future<Either<Failure, List<SalePost>>> call(IdParam params) {
    return repository.getAllPostsByCategory(params.id);
  }
}

import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsByCategory implements Usecase<List<SalePost>, IdParam> {
  final SalePostRepository repository;

  GetAllPostsByCategory({required this.repository});

  @override
  Future<Either<Failure, List<SalePost>>> call(IdParam params) {
    return repository.getAllPostsByCategory(params.id);
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsByOwnerUsecase
    implements Usecase<List<SalePostEntity>, IdParam> {
  final SalePostRepository repository;

  GetAllPostsByOwnerUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SalePostEntity>>> call(IdParam params) {
    return repository.getAllPostsByOwner(params.id);
  }
}

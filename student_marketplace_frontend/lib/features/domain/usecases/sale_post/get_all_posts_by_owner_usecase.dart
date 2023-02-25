import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsByOwnerUsecase
    implements Usecase<List<SalePostEntity>, TokenIdParam> {
  final SalePostRepository repository;

  GetAllPostsByOwnerUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SalePostEntity>>> call(TokenIdParam params) {
    return repository.getAllPostsByOwner(params.token, params.id);
  }
}

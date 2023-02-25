import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsUsecase implements Usecase<List<SalePostEntity>, TokenParam> {
  final SalePostRepository repository;

  GetAllPostsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SalePostEntity>>> call(TokenParam params) {
    return repository.getAllPosts(params.token);
  }
}

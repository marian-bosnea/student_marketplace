import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/sale_post_entity.dart';
import '../../repositories/sale_post_repository.dart';

class GetAllPostsUsecase implements Usecase<List<SalePost>, NoParams> {
  final SalePostRepository repository;

  GetAllPostsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SalePost>>> call(NoParams params) {
    return repository.getAllPosts();
  }
}

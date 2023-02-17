import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/sale_post_repository.dart';

class GetAllPostsUsecase implements Usecase<List<SalePost>, NoParams> {
  final SalePostRepository repository;

  GetAllPostsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SalePost>>> call(NoParams params) {
    return repository.getAllPosts();
  }
}

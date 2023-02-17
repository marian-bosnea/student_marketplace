import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import '../../repositories/user_repository.dart';

import '../../../../core/error/failures.dart';

class GetUserUsecase implements Usecase<bool, IdParam> {
  final UserRepository repository;

  GetUserUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(IdParam params) async {
    return await repository.getUser(params.id);
  }
}

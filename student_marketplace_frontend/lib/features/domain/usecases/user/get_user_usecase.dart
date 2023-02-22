import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

import '../../../../core/error/failures.dart';

class GetUserUsecase implements Usecase<UserEntity, TokenParam> {
  final UserRepository repository;

  GetUserUsecase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(TokenParam params) async {
    return await repository.getUser(params.token);
  }
}

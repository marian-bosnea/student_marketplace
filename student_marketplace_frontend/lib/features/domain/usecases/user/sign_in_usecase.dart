import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_services.dart';

import '../../../../core/error/failures.dart';

class SignInUserUsecase implements Usecase<bool, UserParam> {
  final UserServices repository;

  SignInUserUsecase({required this.repository});

  Future<Either<Failure, bool>> call(UserParam param) {
    return repository.signInUser(param.user);
  }
}

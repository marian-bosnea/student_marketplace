import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import '../../repositories/user_services.dart';

import '../../../../core/error/failures.dart';

class SignUpUsecase implements Usecase<bool, UserParam> {
  final UserServices repository;

  SignUpUsecase({required this.repository});

  Future<Either<Failure, bool>> call(UserParam param) {
    return repository.signUpUser(param.user);
  }
}

import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import '../../repositories/user_services.dart';

import '../../../../core/error/failures.dart';

class SignOutUsecase implements Usecase<bool, UserParam> {
  final UserServices repository;

  SignOutUsecase({required this.repository});

  Future<Either<Failure, bool>> call(UserParam param) {
    return repository.signOutUser(param.user);
  }
}

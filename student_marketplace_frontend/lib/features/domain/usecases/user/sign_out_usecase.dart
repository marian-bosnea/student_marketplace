import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/user_services.dart';

class SignOutUsecase implements Usecase<bool, UserParam> {
  final UserServices repository;

  SignOutUsecase({required this.repository});

  Future<Either<Failure, bool>> call(UserParam param) {
    return repository.signOutUser(param.user);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../operations/user_operations.dart';

import '../../../../core/error/failures.dart';

class SignUpUsecase implements Usecase<bool, UserParam> {
  final UserOperations repository;

  SignUpUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(UserParam param) {
    return repository.signUpUser(param.user);
  }
}

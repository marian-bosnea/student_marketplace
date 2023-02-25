import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_services.dart';

import '../../../../core/error/failures.dart';

class SignInUsecase implements Usecase<String, UserParam> {
  final UserServices repository;

  SignInUsecase({required this.repository});

  Future<Either<Failure, String>> call(UserParam param) {
    return repository.signInUser(param.user);
  }
}

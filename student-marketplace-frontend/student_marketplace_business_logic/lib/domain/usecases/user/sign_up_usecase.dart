import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../operations/user_operations.dart';

import '../../../../core/error/failures.dart';

class SignUpUsecase implements Usecase<bool, UserParam> {
  final UserOperations operations;

  SignUpUsecase({required this.operations});

  @override
  Future<Either<Failure, bool>> call(UserParam param) async {
    return await operations.signUpUser(param.user);
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/user_services.dart';

class CheckEmailRegistration extends Usecase<bool, UserParam> {
  final UserServices repository;

  CheckEmailRegistration({required this.repository});

  @override
  Future<Either<Failure, bool>> call(UserParam params) async =>
      await repository.checkIfEmailIsAvailable(params.user);
}

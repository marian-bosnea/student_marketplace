import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import '../../repositories/user/user_repostory.dart';

import '../../../core/error/failures.dart';

class RegisterUser implements Usecase<bool, NoParams> {
  final UserRepository repository;

  RegisterUser({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams n) async =>
      await repository.registerUser();
}

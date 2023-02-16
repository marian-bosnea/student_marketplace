import 'package:dartz/dartz.dart';
import '../../repositories/user_repostory.dart';

import '../../../core/error/failures.dart';

class RegisterUser {
  final UserRepository repository;

  RegisterUser({required this.repository});

  Future<Either<Failure, bool>> call() async => await repository.registerUser();
}

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, bool>> registerUser();
  Future<Either<Failure, bool>> updateUser();
}

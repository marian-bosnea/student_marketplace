import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

import '../../../core/error/failures.dart';

abstract class UserOperations {
  Future<Either<Failure, bool>> signUpUser(UserEntity user);
}

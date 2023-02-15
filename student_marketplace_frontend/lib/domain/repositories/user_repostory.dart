import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/user/user.dart';

abstract class UserRepository {
  Future<Either<Failure, bool>> registerUser();
  Future<bool> updateUser();
}

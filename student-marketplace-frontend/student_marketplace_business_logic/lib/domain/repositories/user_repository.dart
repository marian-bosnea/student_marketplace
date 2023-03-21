import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserProfile(String token, int? id);
}

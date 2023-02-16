import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/user/user.dart';

abstract class UserService {
  Future<Either<Failure, User>> getUser();
}

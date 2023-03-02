import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/user_entity.dart';

abstract class UserOperationsRemoteDataSource {
  Future<Either<Failure, bool>> signUpUser(UserEntity user);
}

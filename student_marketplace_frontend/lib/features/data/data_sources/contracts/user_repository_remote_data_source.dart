import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class UserRepositoryRemoteDataSource {
  Future<Either<Failure, bool>> getUser(String id);
}

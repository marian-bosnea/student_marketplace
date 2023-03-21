import 'package:dartz/dartz.dart';
import '../../../domain/entities/user_entity.dart';

import '../../../../core/error/failures.dart';

abstract class UserRepositoryRemoteDataSource {
  Future<Either<Failure, UserEntity>> getOwnUserProfile(String token);
  Future<Either<Failure, UserEntity>> getUserProfile(String token, int? id);
}

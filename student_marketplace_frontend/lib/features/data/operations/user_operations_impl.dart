import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/operations/user_operations.dart';
import '../data_sources/contracts/user_services_remote_data_source.dart';

class UserServicesImpl implements UserOperations {
  final UserOperationsRemoteDataSource remoteDataSource;

  const UserServicesImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, bool>> signUpUser(UserEntity user) async {
    return await remoteDataSource.signUpUser(user);
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/operations/user_operations.dart';
import '../contracts/user_services_remote_data_source.dart';

class UserServicesImpl implements UserOperations {
  final UserOperationsRemoteDataSource remoteDataSource;

  const UserServicesImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, bool>> signUpUser(UserEntity user) async =>
      remoteDataSource.signUpUser(user);
}

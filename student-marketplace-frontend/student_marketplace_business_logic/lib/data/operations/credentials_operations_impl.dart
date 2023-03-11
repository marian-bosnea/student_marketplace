import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/credentials_entity.dart';
import '../../domain/operations/credentials_operations.dart';
import '../data_sources/contracts/credentials_remote_data_source.dart';

class CredentialsOperationsImpl extends CredentialsOperations {
  final CredentialsRemoteDataSource credentialsRemoteDataSource;

  CredentialsOperationsImpl({required this.credentialsRemoteDataSource});

  @override
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(
          CredentialsEntity credentials) async =>
      credentialsRemoteDataSource.checkIfEmailIsAvailable(credentials);
}

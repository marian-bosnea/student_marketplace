import 'package:student_marketplace_frontend/features/data/data_sources/contracts/credentials_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/domain/entities/credentials_entity.dart';
import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/domain/operations/credentials_operations.dart';

class CredentialsOperationsImpl extends CredentialsOperations {
  final CredentialsRemoteDataSource credentialsRemoteDataSource;

  CredentialsOperationsImpl({required this.credentialsRemoteDataSource});

  @override
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(
          CredentialsEntity credentials) async =>
      credentialsRemoteDataSource.checkIfEmailIsAvailable(credentials);
}

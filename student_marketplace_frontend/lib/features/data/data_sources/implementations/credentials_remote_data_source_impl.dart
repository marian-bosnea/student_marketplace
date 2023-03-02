import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/credentials_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/domain/entities/credentials_entity.dart';

import '../../../../core/services/http_interface.dart';

class CredentialsRemoteDataSourceImpl extends CredentialsRemoteDataSource {
  final HttpInterface http = HttpInterface();

  @override
  Future<Either<Failure, bool>> checkIfEmailIsAvailable(
      CredentialsEntity credentials) async {
    try {
      final result = await http.checkUserEmail(credentials.email);
      return Right(result);
    } catch (_) {
      return Left(NetworkFailure());
    }
  }
}

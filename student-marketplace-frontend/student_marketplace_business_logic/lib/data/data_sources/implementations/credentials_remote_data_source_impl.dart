import 'package:dartz/dartz.dart';

import '../../../../core/services/http_interface.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/credentials_entity.dart';
import '../contracts/credentials_remote_data_source.dart';

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

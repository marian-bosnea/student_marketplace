
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/user_repository_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/user_services_remote_data_source.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/http_interface.dart';
import '../../../domain/entities/user_entity.dart';

import 'package:dartz/dartz.dart';

class UserOperationsRemoteDataSourceImpl
    implements UserOperationsRemoteDataSource {
  final HttpInterface http = HttpInterface();

  @override
  Future<Either<Failure, bool>> signUpUser(UserEntity user) async {
    try {
      final result = await http.registerUser(user);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }
}

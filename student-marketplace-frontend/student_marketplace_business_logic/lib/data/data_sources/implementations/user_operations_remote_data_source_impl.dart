import '../../../../core/error/failures.dart';
import '../../../../core/services/http_interface.dart';
import '../../../domain/entities/user_entity.dart';

import 'package:dartz/dartz.dart';

import '../contracts/user_services_remote_data_source.dart';

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

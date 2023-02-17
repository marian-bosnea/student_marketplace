import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/user_repository_remote_data_source.dart';

class UserRepositortRemoteDataSourceImpl
    implements UserRepositoryRemoteDataSource {
  @override
  Future<Either<Failure, bool>> getUser(String id) {
    // TODO: implement getUser
    throw UnimplementedError();
  }
}

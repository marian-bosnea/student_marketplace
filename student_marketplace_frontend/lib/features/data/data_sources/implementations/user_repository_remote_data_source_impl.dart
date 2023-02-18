import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../contracts/user_repository_remote_data_source.dart';
import '../../../domain/entities/user_entity.dart';

class UserRepositortRemoteDataSourceImpl
    implements UserRepositoryRemoteDataSource {
  @override
  Future<Either<Failure, UserEntity>> getUser(String id) {
    // TODO: implement getUser
    throw UnimplementedError();
  }
}

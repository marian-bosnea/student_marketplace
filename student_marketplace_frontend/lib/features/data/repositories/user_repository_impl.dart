import '../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../data_sources/contracts/user_repository_remote_data_source.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRepositoryRemoteDataSource remoteDataSource;

  const UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUser(String id) async =>
      remoteDataSource.getUser(id);
}

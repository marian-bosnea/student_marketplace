import 'package:student_marketplace_frontend/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/features/data/data_sources/contracts/user_repository_remote_data_source.dart';
import 'package:student_marketplace_frontend/features/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRepositoryRemoteDataSource remoteDataSource;

  const UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> getUser(String id) async =>
      remoteDataSource.getUser(id);
}

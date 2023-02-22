import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/services/http_interface.dart';
import '../contracts/user_repository_remote_data_source.dart';
import '../../../domain/entities/user_entity.dart';

class UserRepositortRemoteDataSourceImpl
    implements UserRepositoryRemoteDataSource {
  final HttpInterface http = HttpInterface();

  @override
  Future<Either<Failure, UserEntity>> getUser(String token) async {
    final result = await http.fetchUserProfile(token);
    if (result != null) {
      return Right(result);
    }
    return Left(NetworkFailure());
  }
}

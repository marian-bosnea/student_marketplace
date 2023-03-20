import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/services/http_interface.dart';
import '../../models/user_model.dart';
import '../contracts/user_repository_remote_data_source.dart';
import '../../../domain/entities/user_entity.dart';

class UserRepositortRemoteDataSourceImpl
    implements UserRepositoryRemoteDataSource {
  final HttpInterface http = HttpInterface();

  @override
  Future<Either<Failure, UserEntity>> getOwnUserProfile(String token) async {
    UserModel? result = await http.fetchUserProfile(token, null);

    final avatarImageBytes = await http.getUserAvatar(token, null);

    if (result != null) {
      return Right(UserModel(
          firstName: result.firstName,
          lastName: result.lastName,
          secondaryLastName: result.secondaryLastName,
          facultyName: result.facultyName,
          email: result.email,
          avatarImage: avatarImageBytes));
    }

    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile(
      String token, int id) async {
    UserModel? result = await http.fetchUserProfile(token, id);

    final avatarImageBytes = await http.getUserAvatar(token, id);

    if (result != null) {
      return Right(UserModel(
          firstName: result.firstName,
          lastName: result.lastName,
          secondaryLastName: result.secondaryLastName,
          facultyName: result.facultyName,
          email: result.email,
          avatarImage: avatarImageBytes));
    }

    return Left(NetworkFailure());
  }
}

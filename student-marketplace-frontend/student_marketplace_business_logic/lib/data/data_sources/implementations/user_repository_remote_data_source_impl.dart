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
    UserModel? result = await http.fetchOwnUserProfile(token);

    final avatarImageBytes = await http.getUserAvatar(token);

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

import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_session_repository.dart';
import '../../repositories/user_repository.dart';

import '../../../../core/error/failures.dart';

class GetOwnUserProfile implements Usecase<UserEntity, NoParams> {
  final UserRepository userRepository;
  final AuthSessionRepository authRepository;

  GetOwnUserProfile(
      {required this.userRepository, required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    final resultSession = await authRepository.getCachedSession();
    if (resultSession is Left) return Left(UnauthenticatedFailure());

    final session = (resultSession as Right).value;
    final result = await userRepository.getOwnUserProfile(session.token);

    if (result is Left) return Left(NetworkFailure());
    final posts = (result as Right).value;

    return Right(posts);
  }
}

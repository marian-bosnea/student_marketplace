import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_session_repository.dart';
import '../../repositories/user_repository.dart';

import '../../../../core/error/failures.dart';

class GetUserProfileUsecase implements Usecase<UserEntity, OptionalIdParam> {
  final UserRepository userRepository;
  final AuthSessionRepository authRepository;

  GetUserProfileUsecase(
      {required this.userRepository, required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(OptionalIdParam params) async {
    final resultSession = await authRepository.getCachedSession();
    if (resultSession is Left) return Left(UnauthenticatedFailure());

    final session = (resultSession as Right).value;

    final result =
        await userRepository.getUserProfile(session.token, params.id);

    if (result is Left) return Left(NetworkFailure());
    final posts = (result as Right).value;

    return Right(posts);
  }
}

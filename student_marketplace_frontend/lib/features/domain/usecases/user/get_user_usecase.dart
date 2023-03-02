import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_session_repository.dart';
import '../../repositories/user_repository.dart';

import '../../../../core/error/failures.dart';

class GetUserUsecase implements Usecase<UserEntity, IdParam> {
  final UserRepository userRepository;
  final AuthSessionRepository authRepository;

  GetUserUsecase({required this.userRepository, required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(IdParam params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;
    final result = await userRepository.getUser(params.id);

    if (result is Left) return Left(NetworkFailure());
    final posts = (result as Right).value;

    return Right(posts);
  }
}

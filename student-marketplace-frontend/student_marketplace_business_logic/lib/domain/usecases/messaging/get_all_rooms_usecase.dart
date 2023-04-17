import 'package:dartz/dartz.dart';

import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';
import 'package:student_marketplace_business_logic/domain/repositories/auth_session_repository.dart';
import 'package:student_marketplace_business_logic/domain/repositories/room_repository.dart';

class GetAllRoomsUsecase extends Usecase<List<ChatRoomEntity>, NoParams> {
  final AuthSessionRepository authRepository;
  final RoomRepository roomRepository;

  GetAllRoomsUsecase(
      {required this.authRepository, required this.roomRepository});

  @override
  Future<Either<Failure, List<ChatRoomEntity>>> call(NoParams params) async {
    final session = await authRepository.getCachedSession();
    if (session is Left) return Left(UnauthenticatedFailure());

    final token = (session as Right).value;

    final result = await roomRepository.getAll(token.token);
    if (result is Left) return Left(NetworkFailure());

    return result;
  }
}

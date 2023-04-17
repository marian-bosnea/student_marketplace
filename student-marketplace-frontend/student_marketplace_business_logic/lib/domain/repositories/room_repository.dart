import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';

import '../../core/error/failures.dart';

abstract class RoomRepository {
  Future<Either<Failure, List<ChatRoomEntity>>> getAll(String token);
}

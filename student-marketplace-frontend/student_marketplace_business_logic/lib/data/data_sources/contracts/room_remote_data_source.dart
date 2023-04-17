import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/chat_room_entity.dart';

abstract class RoomRemoteDataSource {
  Future<Either<Failure, List<ChatRoomEntity>>> getAll(String token);
}

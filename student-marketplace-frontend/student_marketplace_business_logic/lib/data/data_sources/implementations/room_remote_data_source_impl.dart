import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/core/services/http_interface.dart';
import 'package:student_marketplace_business_logic/data/data_sources/contracts/room_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';

class RoomRemoteDataSourceImpl extends RoomRemoteDataSource {
  final HttpInterface http = HttpInterface();
  @override
  Future<Either<Failure, List<ChatRoomEntity>>> getAll(String token) async {
    try {
      final result = await http.readRooms(token: token);
      return Right(result);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }
}

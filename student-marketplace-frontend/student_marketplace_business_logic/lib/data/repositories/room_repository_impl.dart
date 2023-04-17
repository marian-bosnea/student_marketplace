import 'package:student_marketplace_business_logic/data/data_sources/contracts/room_remote_data_source.dart';
import 'package:student_marketplace_business_logic/domain/entities/chat_room_entity.dart';
import 'package:student_marketplace_business_logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:student_marketplace_business_logic/domain/repositories/room_repository.dart';

class RoomRepositoryImpl extends RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChatRoomEntity>>> getAll(String token) =>
      remoteDataSource.getAll(token);
}

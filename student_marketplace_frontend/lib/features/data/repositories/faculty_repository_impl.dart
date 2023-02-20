import '../data_sources/contracts/faculty_remote_data_source.dart';
import '../../domain/entities/faculty_entity.dart';
import '../../domain/repositories/faculty_repository.dart';

import '../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class FacultyRepositoryImpl implements FacultyRepository {
  final FacultyRemoteDataSource remoteDataSource;

  const FacultyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FacultyEntity>>> getAllFaculties() async =>
      remoteDataSource.getAllFaculties();
}

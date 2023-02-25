import '../../entities/faculty_entity.dart';
import '../../repositories/faculty_repository.dart';

import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllFaculties implements Usecase<List<FacultyEntity>, NoParams> {
  final FacultyRepository repository;

  GetAllFaculties({required this.repository});

  @override
  Future<Either<Failure, List<FacultyEntity>>> call(NoParams params) async =>
      await repository.getAllFaculties();
}

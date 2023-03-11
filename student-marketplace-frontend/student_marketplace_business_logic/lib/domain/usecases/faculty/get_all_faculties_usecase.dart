import '../../../core/usecase/usecase.dart';
import '../../entities/faculty_entity.dart';
import '../../repositories/faculty_repository.dart';

import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class GetAllFacultiesUsecase implements Usecase<List<FacultyEntity>, NoParams> {
  final FacultyRepository repository;

  GetAllFacultiesUsecase({required this.repository});

  @override
  Future<Either<Failure, List<FacultyEntity>>> call(NoParams params) async =>
      await repository.getAllFaculties();
}

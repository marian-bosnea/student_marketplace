import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_marketplace_frontend/features/domain/entities/user_entity.dart';

import '../error/failures.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class IdParam extends Equatable {
  final String id;

  const IdParam({required this.id});

  @override
  List<Object?> get props => [id];
}

class UserParam extends Equatable {
  final UserEntity user;
  const UserParam({required this.user});

  @override
  List<Object?> get props => [user];
}

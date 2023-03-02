import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../features/domain/entities/user_entity.dart';
import '../error/failures.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class CredentialsParams extends Equatable {
  final String email;
  final String password;

  const CredentialsParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class TokenParam extends Equatable {
  final String token;

  const TokenParam({required this.token});

  @override
  List<Object?> get props => [token];
}

class TokenIdParam extends Equatable {
  final String token;
  final String id;

  const TokenIdParam({required this.token, required this.id});

  @override
  List<Object?> get props => [id];
}

class CategoryParam extends Equatable {
  final String token;
  final String categoryId;

  const CategoryParam({required this.token, required this.categoryId});

  @override
  List<Object?> get props => [token, categoryId];
}

class UserParam extends Equatable {
  final UserEntity user;
  const UserParam({required this.user});

  @override
  List<Object?> get props => [user];
}

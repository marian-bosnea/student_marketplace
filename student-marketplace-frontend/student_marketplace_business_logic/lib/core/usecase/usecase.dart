import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/message_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/order_entity.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/credentials_entity.dart';
import '../../domain/entities/sale_post_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../error/failures.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class LimitOffsetParams extends Equatable {
  final int limit;
  final int offset;

  LimitOffsetParams({required this.limit, required this.offset});

  @override
  List<Object?> get props => [limit, offset];
}

class MessageCallbackParam extends Equatable {
  final Function(MessageEntity) callback;

  MessageCallbackParam({required this.callback});

  @override
  List<Object?> get props => [callback];
}

class MessageParam extends Equatable {
  final int roomId;
  final String content;

  MessageParam({required this.roomId, required this.content});

  @override
  List<Object?> get props => [roomId, content];
}

class OrderParam extends Equatable {
  final OrderEntity order;

  OrderParam({required this.order});

  @override
  List<Object?> get props => [order];
}

class AddressParam extends Equatable {
  final AddressEntity address;
  AddressParam({required this.address});

  @override
  List<Object?> get props => [address];
}

class OptionalIdParam extends Equatable {
  final int? id;

  OptionalIdParam({this.id});

  @override
  List<Object?> get props => [id];
}

class BoolParam extends Equatable {
  final bool value;

  const BoolParam({required this.value});
  @override
  List<Object?> get props => [value];
}

class IdParam extends Equatable {
  final int id;

  const IdParam({required this.id});

  @override
  List<Object?> get props => [id];
}

class PostParam extends Equatable {
  final SalePostEntity post;
  const PostParam({required this.post});

  @override
  List<Object?> get props => [post];
}

class CredentialsParams extends Equatable {
  final CredentialsEntity credentials;

  const CredentialsParams({required this.credentials});

  @override
  List<Object?> get props => [credentials];
}

class AuthSessionParam extends Equatable {
  final AuthSessionEntity session;

  const AuthSessionParam({required this.session});

  @override
  List<Object?> get props => [session];
}

class QueryParam extends Equatable {
  final String query;

  const QueryParam({required this.query});

  @override
  List<Object?> get props => [query];
}

class TokenIdParam extends Equatable {
  final String token;
  final String id;

  const TokenIdParam({required this.token, required this.id});

  @override
  List<Object?> get props => [id];
}

class CategoryParam extends Equatable {
  final int categoryId;

  const CategoryParam({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class UserParam extends Equatable {
  final UserEntity user;
  const UserParam({required this.user});

  @override
  List<Object?> get props => [user];
}

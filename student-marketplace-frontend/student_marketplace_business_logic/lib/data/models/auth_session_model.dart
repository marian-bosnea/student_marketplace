import '../../domain/entities/auth_session_entity.dart';

class AuthSessionModel extends AuthSessionEntity {
  const AuthSessionModel({required super.token});

  Map<String, dynamic> toJson() => {'token': super.token};
}

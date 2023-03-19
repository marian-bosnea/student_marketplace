import '../../domain/entities/auth_session_entity.dart';

class AuthSessionModel extends AuthSessionEntity {
  const AuthSessionModel(
      {required super.token, required super.keepPerssistent});

  Map<String, dynamic> toJson() => {'token': super.token};
}

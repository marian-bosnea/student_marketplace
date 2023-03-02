import 'package:equatable/equatable.dart';

abstract class AuthSessionEntity extends Equatable {
  final String token;

  const AuthSessionEntity({required this.token});

  @override
  List<Object?> get props => [token];
}

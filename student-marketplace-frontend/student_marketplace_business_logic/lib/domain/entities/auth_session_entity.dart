import 'package:equatable/equatable.dart';

abstract class AuthSessionEntity extends Equatable {
  final String token;
  final bool keepPerssistent;

  const AuthSessionEntity({required this.token, required this.keepPerssistent});

  @override
  List<Object?> get props => [token, keepPerssistent];
}

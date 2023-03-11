import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  final String token;

  Authenticated({required this.token});

  @override
  List<Object?> get props => [token];
}

class Unauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

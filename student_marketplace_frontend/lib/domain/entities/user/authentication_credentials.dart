import 'package:equatable/equatable.dart';

class AuthenticationCredentials extends Equatable {
  final String email;
  final String password;

  const AuthenticationCredentials(
      {required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

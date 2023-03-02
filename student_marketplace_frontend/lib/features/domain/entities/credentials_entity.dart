import 'package:equatable/equatable.dart';

abstract class CredentialsEntity extends Equatable {
  final String email;
  final String password;

  const CredentialsEntity({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

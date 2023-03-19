import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class NullField extends Failure {
  @override
  List<Object?> get props => [];
}

class TokenNotFound extends Failure {
  @override
  List<Object?> get props => [];
}

class UnauthenticatedFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {
  @override
  List<Object?> get props => [];
}

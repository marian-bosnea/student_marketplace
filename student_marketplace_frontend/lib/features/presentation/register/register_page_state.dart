import 'package:equatable/equatable.dart';

abstract class RegisterPageState extends Equatable {}

class InitialRegisterState extends RegisterPageState {
  @override
  List<Object?> get props => [];
}

class RegisterValidEmail extends RegisterPageState {
  @override
  List<Object?> get props => [];
}

class RegisterInvalidEmail extends RegisterPageState {
  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterPageState {
  @override
  List<Object?> get props => [];
}

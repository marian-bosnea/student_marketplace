// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../core/enums.dart';

class LoginPageState extends Equatable {
  final bool isEmailCorrect;
  final bool keepSignedIn;
  final bool isEmailFieldFocused;
  final bool isPasswordFieldFocused;
  final FormStatus status;

  const LoginPageState({
    this.isEmailCorrect = false,
    this.keepSignedIn = false,
    this.isEmailFieldFocused = false,
    this.isPasswordFieldFocused = false,
    this.status = FormStatus.intial,
  });

  LoginPageState copyWith(
      {bool? isEmailCorrect,
      bool? keepSignedIn,
      bool? isEmailFieldFocused,
      bool? isPasswordFieldFocused,
      String? email,
      String? password,
      FormStatus? status}) {
    return LoginPageState(
        isEmailCorrect: isEmailCorrect ?? this.isEmailCorrect,
        isEmailFieldFocused: isEmailFieldFocused ?? this.isEmailFieldFocused,
        isPasswordFieldFocused:
            isPasswordFieldFocused ?? this.isPasswordFieldFocused,
        keepSignedIn: keepSignedIn ?? false,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [
        isEmailCorrect,
        isEmailFieldFocused,
        isPasswordFieldFocused,
        keepSignedIn,
        status
      ];
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum LoginPageStatus {
  intial,
  emailSubmitting,
  emailSucces,
  passwordSubmitting,
  loginSuccesful,
  loginFailed
}

class LoginPageState extends Equatable {
  final bool keepSignedIn;
  final bool isEmailPrefixActive;
  final bool isPasswordPrefixActive;
  final LoginPageStatus status;

  const LoginPageState({
    this.keepSignedIn = false,
    this.isEmailPrefixActive = false,
    this.isPasswordPrefixActive = false,
    this.status = LoginPageStatus.intial,
  });

  LoginPageState copyWith(
      {bool? isEmailCorrect,
      bool? keepSignedIn,
      bool? isEmailPrefixActive,
      bool? isPasswordPrefixActive,
      String? email,
      String? password,
      LoginPageStatus? status}) {
    return LoginPageState(
        isEmailPrefixActive: isEmailPrefixActive ?? this.isEmailPrefixActive,
        isPasswordPrefixActive:
            isPasswordPrefixActive ?? this.isPasswordPrefixActive,
        keepSignedIn: keepSignedIn ?? false,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props =>
      [isEmailPrefixActive, isPasswordPrefixActive, keepSignedIn, status];
}

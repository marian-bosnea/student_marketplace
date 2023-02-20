// ignore_for_file: public_member_api_docs, sort_constructors_first
enum LoginStatus {
  intial,
  inProgress,
  submittingLoading,
  succesSubmission,
  failedSubmission,
}

class LoginPageState {
  final bool isEmailCorrect;
  final bool keepSignedIn;
  final bool isEmailFieldFocused;
  final bool isPasswordFieldFocused;
  final String email;
  final String password;
  final LoginStatus status;

  LoginPageState({
    this.isEmailCorrect = false,
    this.keepSignedIn = false,
    this.isEmailFieldFocused = false,
    this.isPasswordFieldFocused = false,
    this.email = '',
    this.password = '',
    this.status = LoginStatus.intial,
  });

  LoginPageState copyWith(
      {bool? isEmailCorrect,
      bool? keepSignedIn,
      bool? isEmailFieldFocused,
      bool? isPasswordFieldFocused,
      String? email,
      String? password,
      LoginStatus? status}) {
    return LoginPageState(
        isEmailCorrect: isEmailCorrect ?? this.isEmailCorrect,
        isEmailFieldFocused: isEmailFieldFocused ?? this.isEmailFieldFocused,
        isPasswordFieldFocused:
            isPasswordFieldFocused ?? this.isPasswordFieldFocused,
        email: email ?? this.email,
        password: password ?? this.password,
        keepSignedIn: keepSignedIn ?? false,
        status: status ?? this.status);
  }
}

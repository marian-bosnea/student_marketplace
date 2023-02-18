import 'login_form_submission_status.dart';

class LoginState {
  final String email;
  final String password;

  final FormSubmissionStatus status;

  bool get isValid => email.isNotEmpty && email.isNotEmpty;

  LoginState(
      {this.email = ' ',
      this.password = '',
      this.status = const InitalFormStatus()});

  LoginState copyWith(
      {String? email, String? password, FormSubmissionStatus? status}) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status);
  }
}

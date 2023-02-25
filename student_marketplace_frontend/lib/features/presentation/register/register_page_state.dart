// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum RegisterPageStatus {
  credentialsInProgress,
  validCredentials,
  personalInfoInProgress,
  validPersonalInfo,
  submissionSuccessful,
  submissionFailed
}

class RegisterPageState extends Equatable {
  final bool showEmailCheckmark;
  final bool showPasswordWarning;
  final bool showConfirmPasswordWarning;
  final String emailValue;
  final String passwordValue;
  final String confirmPasswordValue;
  final RegisterPageStatus status;

  const RegisterPageState(
      {this.status = RegisterPageStatus.credentialsInProgress,
      this.showEmailCheckmark = false,
      this.showPasswordWarning = false,
      this.showConfirmPasswordWarning = false,
      this.emailValue = '',
      this.passwordValue = '',
      this.confirmPasswordValue = ''});

  RegisterPageState copyWith(
          {bool? showEmailCheckmark,
          bool? showPasswordWarning,
          bool? showConfirmPasswordWarning,
          String? emailValue,
          String? passwordValue,
          String? confirmPasswordValue,
          RegisterPageStatus? status}) =>
      RegisterPageState(
          showEmailCheckmark: showEmailCheckmark ?? this.showEmailCheckmark,
          showPasswordWarning: showPasswordWarning ?? this.showPasswordWarning,
          showConfirmPasswordWarning:
              showConfirmPasswordWarning ?? this.showConfirmPasswordWarning,
          status: status ?? this.status,
          emailValue: emailValue ?? this.emailValue,
          passwordValue: passwordValue ?? this.passwordValue,
          confirmPasswordValue:
              confirmPasswordValue ?? this.confirmPasswordValue);

  @override
  List<Object?> get props => [
        showEmailCheckmark,
        showPasswordWarning,
        showConfirmPasswordWarning,
        status
      ];
}

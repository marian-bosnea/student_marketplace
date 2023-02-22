// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:student_marketplace_frontend/core/enums.dart';

class RegisterPageState extends Equatable {
  final bool showEmailCheckmark;
  final bool showPasswordWarning;
  final bool showConfirmPasswordWarning;
  final FormStatus status;

  const RegisterPageState(
      {this.status = FormStatus.intial,
      this.showEmailCheckmark = false,
      this.showPasswordWarning = false,
      this.showConfirmPasswordWarning = false});

  RegisterPageState copyWith(
          {bool? showEmailCheckmark,
          bool? showPasswordWarning,
          bool? showConfirmPasswordWarning,
          FormStatus? status}) =>
      RegisterPageState(
          showEmailCheckmark: showEmailCheckmark ?? this.showEmailCheckmark,
          showPasswordWarning:
              showPasswordWarning ?? this.showConfirmPasswordWarning,
          showConfirmPasswordWarning:
              showConfirmPasswordWarning ?? this.showConfirmPasswordWarning,
          status: status ?? this.status);

  @override
  List<Object?> get props => [
        showEmailCheckmark,
        showPasswordWarning,
        showConfirmPasswordWarning,
        status
      ];
}

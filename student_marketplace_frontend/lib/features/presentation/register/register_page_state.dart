// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:student_marketplace_frontend/features/domain/entities/faculty_entity.dart';

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
  final List<FacultyEntity> faculties;
  final RegisterPageStatus status;

  late Uint8List? avatarImage;

  RegisterPageState(
      {this.status = RegisterPageStatus.credentialsInProgress,
      this.showEmailCheckmark = false,
      this.showPasswordWarning = false,
      this.showConfirmPasswordWarning = false,
      this.faculties = const [],
      this.emailValue = '',
      this.avatarImage,
      this.passwordValue = '',
      this.confirmPasswordValue = ''});

  RegisterPageState copyWith(
          {bool? showEmailCheckmark,
          bool? showPasswordWarning,
          bool? showConfirmPasswordWarning,
          String? emailValue,
          String? passwordValue,
          String? confirmPasswordValue,
          Uint8List? avatarImage,
          List<FacultyEntity>? faculties,
          RegisterPageStatus? status}) =>
      RegisterPageState(
          showEmailCheckmark: showEmailCheckmark ?? this.showEmailCheckmark,
          showPasswordWarning: showPasswordWarning ?? this.showPasswordWarning,
          showConfirmPasswordWarning:
              showConfirmPasswordWarning ?? this.showConfirmPasswordWarning,
          status: status ?? this.status,
          emailValue: emailValue ?? this.emailValue,
          passwordValue: passwordValue ?? this.passwordValue,
          avatarImage: avatarImage ?? this.avatarImage,
          confirmPasswordValue:
              confirmPasswordValue ?? this.confirmPasswordValue,
          faculties: faculties ?? this.faculties);

  @override
  List<Object?> get props => [
        showEmailCheckmark,
        emailValue,
        passwordValue,
        confirmPasswordValue,
        showPasswordWarning,
        showConfirmPasswordWarning,
        status
      ];
}

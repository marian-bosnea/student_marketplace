// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/faculty_entity.dart';

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
  final bool hasUploadedPhoto;
  final String emailValue;
  final String passwordValue;
  final String confirmPasswordValue;
  final String firstNameValue;
  final String lastNameValue;
  final String secondLastNameValue;
  final String selectedFacultyId;
  final List<FacultyEntity> faculties;
  final RegisterPageStatus status;

  final Uint8List? avatarImage;

  const RegisterPageState(
      {this.status = RegisterPageStatus.credentialsInProgress,
      this.showEmailCheckmark = false,
      this.showPasswordWarning = false,
      this.showConfirmPasswordWarning = false,
      this.hasUploadedPhoto = false,
      this.faculties = const [],
      this.emailValue = '',
      this.avatarImage,
      this.passwordValue = '',
      this.firstNameValue = '',
      this.lastNameValue = '',
      this.secondLastNameValue = '',
      this.selectedFacultyId = '',
      this.confirmPasswordValue = ''});

  RegisterPageState copyWith(
          {bool? showEmailCheckmark,
          bool? showPasswordWarning,
          bool? showConfirmPasswordWarning,
          bool? hasUploadedPhoto,
          String? emailValue,
          String? passwordValue,
          String? confirmPasswordValue,
          String? firstNameValue,
          String? lastNameValue,
          String? secondLastNameValue,
          Uint8List? avatarImage,
          List<FacultyEntity>? faculties,
          String? selectedFacultyId,
          RegisterPageStatus? status}) =>
      RegisterPageState(
          showEmailCheckmark: showEmailCheckmark ?? this.showEmailCheckmark,
          showPasswordWarning: showPasswordWarning ?? this.showPasswordWarning,
          showConfirmPasswordWarning:
              showConfirmPasswordWarning ?? this.showConfirmPasswordWarning,
          hasUploadedPhoto: hasUploadedPhoto ?? this.hasUploadedPhoto,
          status: status ?? this.status,
          emailValue: emailValue ?? this.emailValue,
          passwordValue: passwordValue ?? this.passwordValue,
          avatarImage: avatarImage ?? this.avatarImage,
          selectedFacultyId: selectedFacultyId ?? this.selectedFacultyId,
          confirmPasswordValue:
              confirmPasswordValue ?? this.confirmPasswordValue,
          firstNameValue: firstNameValue ?? this.firstNameValue,
          lastNameValue: lastNameValue ?? this.lastNameValue,
          secondLastNameValue: secondLastNameValue ?? this.secondLastNameValue,
          faculties: faculties ?? this.faculties);

  @override
  List<Object?> get props => [
        showEmailCheckmark,
        emailValue,
        hasUploadedPhoto,
        passwordValue,
        firstNameValue,
        lastNameValue,
        secondLastNameValue,
        confirmPasswordValue,
        showPasswordWarning,
        showConfirmPasswordWarning,
        status,
        avatarImage,
        selectedFacultyId
      ];
}

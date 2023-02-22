// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../core/enums.dart';

class ProfilePageState extends Equatable {
  final String firstName;
  final String lastName;
  final String secondLastName;
  final String emailAdress;
  final String facultyName;
  final ProfilePageStatus status;

  const ProfilePageState(
      {this.firstName = '',
      this.lastName = '',
      this.secondLastName = '',
      this.emailAdress = '',
      this.facultyName = '',
      this.status = ProfilePageStatus.initial});

  ProfilePageState copyWith(
          {String? firstName,
          String? lastName,
          String? secondLastName,
          String? emailAdress,
          String? facultyName,
          ProfilePageStatus? status}) =>
      ProfilePageState(
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          secondLastName: secondLastName ?? this.secondLastName,
          emailAdress: emailAdress ?? this.emailAdress,
          facultyName: facultyName ?? this.facultyName,
          status: status ?? this.status);

  @override
  List<Object?> get props =>
      [firstName, lastName, secondLastName, emailAdress, facultyName, status];
}

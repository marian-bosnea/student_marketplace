// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../core/constants/enums.dart';

class ProfileViewState extends Equatable {
  final String firstName;
  final String lastName;
  final String secondLastName;
  final String emailAdress;
  final String facultyName;
  final Uint8List? avatarBytes;
  final ProfilePageStatus status;

  const ProfileViewState(
      {this.firstName = '',
      this.lastName = '',
      this.secondLastName = '',
      this.emailAdress = '',
      this.avatarBytes,
      this.facultyName = '',
      this.status = ProfilePageStatus.initial});

  ProfileViewState copyWith(
          {String? firstName,
          String? lastName,
          String? secondLastName,
          String? emailAdress,
          String? facultyName,
          Uint8List? avatarBytes,
          ProfilePageStatus? status}) =>
      ProfileViewState(
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          secondLastName: secondLastName ?? this.secondLastName,
          emailAdress: emailAdress ?? this.emailAdress,
          facultyName: facultyName ?? this.facultyName,
          avatarBytes: avatarBytes ?? this.avatarBytes,
          status: status ?? this.status);

  @override
  List<Object?> get props =>
      [firstName, lastName, secondLastName, emailAdress, facultyName, status];
}

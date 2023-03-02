import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? secondaryLastName;
  final String? facultyName;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final Uint8List? avatarImage;

  const UserEntity(
      {this.firstName,
      this.avatarImage,
      this.lastName,
      this.secondaryLastName,
      this.facultyName,
      this.email,
      this.password,
      this.confirmPassword});

  @override
  List<Object?> get props =>
      [firstName, lastName, secondaryLastName, facultyName, email];
}

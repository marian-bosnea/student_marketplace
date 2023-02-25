import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? secondaryLastName;
  final String? facultyName;
  final Uint8List? avatarImage;

  final List? posts;

  /// Credentials
  final String? email;
  final String? password;

  final String? authToken;

  const UserEntity(
      {this.firstName,
      this.avatarImage,
      this.lastName,
      this.secondaryLastName,
      this.facultyName,
      this.email,
      this.password,
      this.posts,
      this.authToken});

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        secondaryLastName,
        facultyName,
        email,
        password,
        posts,
        authToken
      ];
}

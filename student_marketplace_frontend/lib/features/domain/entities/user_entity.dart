import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? secondaryLastName;
  final String? facultyName;

  final List? posts;

  /// Credentials
  final String? email;
  final String? password;

  final String? id;

  const UserEntity(
      {this.firstName,
      this.lastName,
      this.secondaryLastName,
      this.facultyName,
      this.email,
      this.password,
      this.posts,
      this.id});

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        secondaryLastName,
        facultyName,
        email,
        password,
        posts,
        id
      ];
}

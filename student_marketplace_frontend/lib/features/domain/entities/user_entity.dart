import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String? secondaryLastName;
  final String facultyName;

  final List? posts;

  /// Credentials
  final String email;
  final String password;

  final String? id;

  const UserEntity(
      {required this.firstName,
      required this.lastName,
      required this.secondaryLastName,
      required this.facultyName,
      required this.email,
      required this.password,
      required this.posts,
      required this.id});

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

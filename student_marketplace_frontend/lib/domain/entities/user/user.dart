import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String firstName;
  final String lastName;
  final String? secondaryLastName;
  final String facultyName;
  final String emailAddress;

  const User({
    required this.lastName,
    required this.secondaryLastName,
    required this.facultyName,
    required this.emailAddress,
    required this.firstName,
  });

  @override
  List<Object?> get props =>
      [firstName, lastName, secondaryLastName, facultyName, emailAddress];
}

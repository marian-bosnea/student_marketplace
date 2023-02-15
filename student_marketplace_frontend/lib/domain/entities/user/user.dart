import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String firstName;
  final String lastname;
  final String? secondaryLastName;
  final String facultyName;
  final String emailAddress;

  const User({
    required this.lastname,
    required this.secondaryLastName,
    required this.facultyName,
    required this.emailAddress,
    required this.firstName,
  });

  @override
  List<Object?> get props =>
      [firstName, lastname, secondaryLastName, facultyName, emailAddress];
}

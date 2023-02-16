import '../../../domain/entities/user/user.dart';

class UserModel extends User {
  UserModel(
      {required super.lastName,
      required super.secondaryLastName,
      required super.facultyName,
      required super.emailAddress,
      required super.firstName});

  static UserModel? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return null;

    if (!json.containsKey('firstName') ||
        !json.containsKey('lastName') ||
        !json.containsKey('emailAddress') ||
        !json.containsKey('facultyName')) {
      return null;
    }

    String? secondaryLastName = json.containsKey('secondaryLastName')
        ? json['secondaryLastName']
        : null;

    return UserModel(
        lastName: json['lastName'],
        secondaryLastName: secondaryLastName,
        facultyName: json['facultyName'],
        emailAddress: json['emailAddress'],
        firstName: json['firstName']);
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      if (secondaryLastName != null) 'secondaryLastName': secondaryLastName,
      'emailAddress': emailAddress,
      'facultyName': facultyName
    };
  }
}

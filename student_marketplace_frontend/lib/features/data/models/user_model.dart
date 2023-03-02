import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.firstName,
    super.lastName,
    super.secondaryLastName,
    super.facultyName,
    super.email,
    super.password,
    super.confirmPassword,
    super.avatarImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? secondaryLastName;
    if (json.containsKey('secondaryLastName')) {
      secondaryLastName = json['secondaryLastName'];
    }

    return UserModel(
        firstName: json['firstName'],
        lastName: json['lastName'],
        secondaryLastName: secondaryLastName,
        facultyName: json['facultyName'],
        email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      if (secondaryLastName != null) 'secondaryLastName': secondaryLastName,
      'password': password,
      'passwordConfirm': confirmPassword,
      'facultyName': facultyName,
      'email': email,
    };
  }
}

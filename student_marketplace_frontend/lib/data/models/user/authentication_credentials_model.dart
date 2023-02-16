import 'package:student_marketplace_frontend/domain/entities/user/authentication_credentials.dart';

class AuthenticationCredentialsModel extends AuthenticationCredentials {
  const AuthenticationCredentialsModel(
      {required super.email, required super.password});

  static AuthenticationCredentialsModel? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return null;

    if (!json.containsKey('email') || !json.containsKey('password')) {
      return null;
    }

    return AuthenticationCredentialsModel(
        email: json['email'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

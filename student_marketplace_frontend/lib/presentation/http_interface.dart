import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/user_profile.dart';

class HttpInterface {
  final ip = "192.168.0.105";
  final port = "3000";

  late String token;

  final baseUrl = "http://192.168.0.105:3000";
  final int getSuccessCode = 200;
  final int postSuccessCode = 201;

  final int unauthorizedCode = 401;
  final int forbiddenCode = 403;

  Future<bool> checkUserEmail(String email) async {
    final requestUrl = "$baseUrl/users/check-email";

    final response = await http.post(Uri.parse(requestUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{'email': email}));

    return response.statusCode == postSuccessCode;
  }

  Future<bool> logUser(String email, String password) async {
    final requestUrl = "$baseUrl/users/login/local-strategy";

    final response = await http.post(Uri.parse(requestUrl),
        headers: {"Content-Type": "application/json"},
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    if (response.statusCode != postSuccessCode) return false;

    final map = json.decode(response.body) as Map<String, dynamic>;
    token = map['accessToken'] as String;

    return true;
  }

  Future<UserProfile?> fetchUserProfile() async {
    final requestUrl = "$baseUrl/user/get/profile";

    print(token);

    final response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      },
    );

    if (response.statusCode != getSuccessCode) return null;
    final resultJson = json.decode(response.body) as Map<String, dynamic>;
    print(resultJson.toString());

    return UserProfile.fromJson(resultJson);
  }
}

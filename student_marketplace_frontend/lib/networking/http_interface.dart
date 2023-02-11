import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpInterface {
  final ip = "192.168.0.105";
  final port = "3000";

  final baseUrl = "http://192.168.0.105:3000";
  final int successStatusCode = 201;

  Future<bool> checkUserEmail(String email) async {
    final requestUrl = "$baseUrl/users/check-email";

    final response = await http.post(Uri.parse(requestUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{'email': email}));

    return response.statusCode == successStatusCode;
  }

  Future<bool> logUser(String email, String password) async {
    final requestUrl = "$baseUrl/users/login/local-strategy";

    final response = await http.post(Uri.parse(requestUrl),
        headers: {"Content-Type": "application/json"},
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == successStatusCode) {
      return true;
    }

    return false;
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:student_marketplace_frontend/features/data/models/sale_post_model.dart';

import '../../features/data/models/user_model.dart';
import '../../features/domain/entities/user_entity.dart';

class HttpInterface {
  final ip = "192.168.0.105";
  final port = "3000";

  final baseUrl = "http://192.168.0.106:3000";
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

  Future<String> signInUser(String email, String password) async {
    final requestUrl = "$baseUrl/users/login/local-strategy";
    try {
      final response = await http.post(Uri.parse(requestUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              <String, String>{'email': email, 'password': password}));

      if (response.statusCode != postSuccessCode) throw Exception();

      final map = json.decode(response.body) as Map<String, dynamic>;
      final token = map['accessToken'] as String;

      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> registerUser(UserEntity user) async {
    final requestUrl = "$baseUrl/users/register";
    try {
      final response = await http.post(Uri.parse(requestUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(<String, String>{
            'email': user.email!,
            'password': user.password!,
            'passwordConfirm': user.password!,
            'firstName': user.firstName!,
            'lastName': user.lastName!,
            'secondaryLastName': user.secondaryLastName ?? 'null',
            'facultyId': user.facultyName!
          }));

      if (response.statusCode != postSuccessCode) return false;

      final map = json.decode(response.body) as Map<String, dynamic>;
      final token = map['accessToken'] as String;

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isUserLoggedIn(String token) async {
    final requestUrl = "$baseUrl/users/check-authentication";
    try {
      final response = await http.get(
        Uri.parse(requestUrl),
        headers: {
          "Content-Type": "application/json",
          'authorization': 'Bearer $token'
        },
      );

      return response.statusCode == getSuccessCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logOutUser(String token) async {
    final requestUrl = "$baseUrl/users/logout";
    try {
      final response = await http.get(
        Uri.parse(requestUrl),
        headers: {
          "Content-Type": "application/json",
          'authorization': 'Bearer $token'
        },
      );

      return response.statusCode == getSuccessCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> getUserAvatar(String token) async {
    final requestUrl = "$baseUrl/user/get/avatar_image";
    final response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      },
    );
    final a = response.bodyBytes;

    return response.bodyBytes;
  }

  Future<List<SalePostModel>?> fetchAllSalePosts(String token) async {
    final requestUrl = "$baseUrl/sale-object/get/all";
    final response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      },
    );

    if (response.statusCode != getSuccessCode) return null;
    final bodyJson = json.decode(response.body) as Map<String, dynamic>;
    final resultJson = bodyJson['results'];

    List<SalePostModel> salePosts = [];

    for (var json in resultJson) {
      final map = json as Map<String, dynamic>;
      salePosts.add(SalePostModel.fromJson(json));
    }

    return salePosts;
  }

  Future<UserModel?> fetchUserProfile(String token) async {
    final requestUrl = "$baseUrl/user/get/profile";

    final response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      },
    );

    if (response.statusCode != getSuccessCode) return null;
    final resultJson = json.decode(response.body) as Map<String, dynamic>;

    return UserModel.fromJson(resultJson);
  }
}

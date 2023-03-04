import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:student_marketplace_frontend/features/data/data_sources/implementations/product_category_remote_data_source_impl.dart';
import 'package:student_marketplace_frontend/features/data/models/faculty_model.dart';
import 'package:student_marketplace_frontend/features/data/models/product_category_model.dart';
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
      var request = http.MultipartRequest('POST', Uri.parse(requestUrl));

      request.headers.addAll({"Content-type": "multipart/form-data"});

      final file = http.MultipartFile.fromBytes(
          'avatarImage', user.avatarImage!,
          filename: 'avatar.jpg', contentType: MediaType('image', 'jpeg'));

      request.fields['email'] = user.email!;
      request.fields['firstName'] = user.firstName!;
      request.fields['lastName'] = user.lastName!;
      request.fields['password'] = user.password!;
      request.fields['passwordConfirm'] = user.confirmPassword!;
      request.fields['facultyId'] = user.facultyName!;

      request.files.add(file);

      var response = await request.send();

      if (response.statusCode != postSuccessCode) return false;
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

  Future<UserModel?> fetchOwnUserProfile(String token) async {
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

  Future<List<ProductCategoryModel>> fetchAllCategories(String token) async {
    final requestUrl = "$baseUrl/product-categories/get/all";

    final response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      },
    );

    final bodyJson = json.decode(response.body) as Map<String, dynamic>;
    final resultJson = bodyJson['object_categories'];

    List<ProductCategoryModel> categories = [];

    for (var json in resultJson) {
      final map = json as Map<String, dynamic>;
      categories.add(ProductCategoryModel.fromJson(json)!);
    }
    return categories;
  }

  Future<List<FacultyModel>> fetchAllFaculties() async {
    final requestUrl = "$baseUrl/faculties/get/all";
    final response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final bodyJson = json.decode(response.body) as Map<String, dynamic>;
    final resultJson = bodyJson['faculties'];

    List<FacultyModel> faculties = [];

    for (var json in resultJson) {
      final map = json as Map<String, dynamic>;
      faculties.add(FacultyModel.fromJson(json));
    }
    return faculties;
  }
}

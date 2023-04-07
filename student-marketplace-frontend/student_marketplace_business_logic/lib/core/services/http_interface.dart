import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:student_marketplace_business_logic/data/models/address_model.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

import '../../data/models/faculty_model.dart';
import '../../data/models/product_category_model.dart';
import '../../data/models/sale_post_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/sale_post_entity.dart';
import '../../domain/entities/user_entity.dart';

class HttpInterface {
  final ip = "192.168.0.105";
  final port = "3000";

  final baseUrl = "http://192.168.0.101:3000";
  //final baseUrl = "http://bore.pub:35701";
  //final baseUrl = ' https://7776-212-93-144-202.eu.ngrok.io';
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

  Future<Uint8List> getUserAvatar(String token, int? id) async {
    id ??= -1;

    final requestUrl = "$baseUrl/user/get/avatar_image";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'userId': id}));

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

      final imageRequestUrl = "$baseUrl/sale-object/get/image";
      final imageResponse = await http.post(Uri.parse(imageRequestUrl),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{'postId': map['id'], 'index': 0}));

      // print(imageResponse.statusCode);

      salePosts.add(
        SalePostModel(
            postId: map['id'],
            title: map['title'],
            price: map['price'].toString(),
            viewsCount: map['views_count'],
            images: [imageResponse.bodyBytes],
            isFavorite: map['is_favorite'] as bool,
            isOwn: map['is_own'] as bool),
      );
    }

    return salePosts;
  }

  Future<SalePostModel?> fetchDetailedSalePost(
      {required String token, required int postId}) async {
    final requestUrl = "$baseUrl/sale-object/get/detailed";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'postId': postId}));

    if (response.statusCode != getSuccessCode) return null;
    final bodyJson = json.decode(response.body) as Map<String, dynamic>;
    final results = bodyJson['results'];
    final resultJson = results.first;

    final imgCountStr = resultJson['images_count'] as String;
    final imagesCount = int.parse(imgCountStr);
    List<Uint8List> images = [];

    for (int i = 0; i < imagesCount; i++) {
      final imageRequestUrl = "$baseUrl/sale-object/get/image";
      final imageResponse = await http.post(Uri.parse(imageRequestUrl),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, String>{
            'postId': resultJson['id'].toString(),
            'index': '$i'
          }));
      images.add(imageResponse.bodyBytes);
    }

    return SalePostModel(
        postId: resultJson['id'],
        title: resultJson['title'],
        description: resultJson['description'],
        price: resultJson['price'].toString(),
        postingDate: resultJson['date'],
        categoryName: resultJson['category_name'],
        viewsCount: resultJson['views_count'],
        ownerId: resultJson['owner_id'],
        ownerName: resultJson['owner_name'],
        isOwn: resultJson['is_own'],
        images: images);
  }

  Future<List<SalePostModel>?> fetchAllSalePostsOfCategory(
      {required String token, required int categoryId}) async {
    final requestUrl = "$baseUrl/sale-object/get/category";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'categoryId': categoryId}));

    if (response.statusCode != getSuccessCode) return null;
    final bodyJson = json.decode(response.body) as Map<String, dynamic>;
    final resultJson = bodyJson['results'];
    List<SalePostModel> salePosts = [];

    for (var json in resultJson) {
      final map = json as Map<String, dynamic>;

      final imageRequestUrl = "$baseUrl/sale-object/get/image";
      final imageResponse = await http.post(Uri.parse(imageRequestUrl),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: jsonEncode(
              <String, String>{'postId': map['id'].toString(), 'index': '0'}));

      salePosts.add(SalePostModel(
          postId: map['id'],
          title: map['title'],
          price: map['price'].toString(),
          viewsCount: map['views_count'] as int,
          isFavorite: map['is_favorite'] as bool,
          isOwn: map['is_own'] as bool,
          images: [imageResponse.bodyBytes]));
    }

    return salePosts;
  }

  Future<List<SalePostModel>?> fetchAllPostsByQuery(
      {required String token, required String query}) async {
    final requestUrl = "$baseUrl/sale-object/get/query";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{'query': query}));

    if (response.statusCode != getSuccessCode) return null;
    final bodyJson = json.decode(response.body) as Map<String, dynamic>;
    final resultJson = bodyJson['results'];
    List<SalePostModel> salePosts = [];

    for (var json in resultJson) {
      final map = json as Map<String, dynamic>;

      final imageRequestUrl = "$baseUrl/sale-object/get/image";
      final imageResponse = await http.post(Uri.parse(imageRequestUrl),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: jsonEncode(
              <String, String>{'postId': map['id'].toString(), 'index': '0'}));

      salePosts.add(SalePostModel(
          postId: map['id'],
          title: map['title'],
          price: map['price'].toString(),
          viewsCount: map['views_count'] as int,
          isFavorite: map['is_favorite'] as bool,
          isOwn: map['is_own'] as bool,
          categoryId: map['category_id'] as int,
          images: [imageResponse.bodyBytes]));
    }
    return salePosts;
  }

  Future<List<SalePostModel>?> fetchAllPostsByOwner(
      {required String token, required int? id}) async {
    final requestUrl = "$baseUrl/sale-object/get/owner";

    id ??= -1;

    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'ownerId': id}));

    if (response.statusCode != getSuccessCode) return null;

    final bodyJson = json.decode(response.body) as Map<String, dynamic>;
    final resultJson = bodyJson['results'];

    List<SalePostModel> salePosts = [];

    for (var json in resultJson) {
      final map = json as Map<String, dynamic>;

      final imageRequestUrl = "$baseUrl/sale-object/get/image";
      final imageResponse = await http.post(Uri.parse(imageRequestUrl),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: jsonEncode(
              <String, String>{'postId': map['id'].toString(), 'index': '0'}));

      salePosts.add(SalePostModel(
          postId: map['id'],
          title: map['title'],
          price: map['price'].toString(),
          viewsCount: map['views_count'] as int,
          postingDate: map['date'],
          categoryName: map['category_name'],
          images: [imageResponse.bodyBytes]));
    }
    return salePosts;
  }

  Future<List<SalePostModel>?> fetchFavoritePosts(String token) async {
    final requestUrl = "$baseUrl/sale-object/favorites/read-all";
    final response = await http.post(
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

      final imageRequestUrl = "$baseUrl/sale-object/get/image";
      final imageResponse = await http.post(Uri.parse(imageRequestUrl),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: jsonEncode(
              <String, String>{'postId': map['id'].toString(), 'index': '0'}));

      // print(imageResponse.statusCode);

      salePosts.add(SalePostModel(
          postId: map['id'],
          title: map['title'],
          price: map['price'].toString(),
          ownerName: map['owner_name'].toString(),
          categoryName: map['category_name'].toString(),
          ownerId: map['owner_id'] as int,
          viewsCount: map['views_count'] as int,
          images: [imageResponse.bodyBytes]));
    }
    return salePosts;
  }

  Future<UserModel?> fetchUserProfile(String token, int? id) async {
    final requestUrl = "$baseUrl/user/get/profile";

    id ??= -1;

    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'userId': id}));

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
      faculties.add(FacultyModel.fromJson(json));
    }
    return faculties;
  }

  Future<bool> uploadPost(SalePostEntity post, String token) async {
    final requestUrl = "$baseUrl/sale-object/post";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(requestUrl));

      request.headers.addAll({
        "authorization": "Bearear $token",
        "Content-type": "multipart/form-data"
      });

      for (int i = 0; i < post.images.length; i++) {
        final file = http.MultipartFile.fromBytes('images', post.images[i],
            filename: 'images$i.jpg', contentType: MediaType('image', 'jpeg'));
        request.files.add(file);
      }

      request.fields['title'] = post.title;
      request.fields['description'] = post.description!;
      request.fields['price'] = post.price;
      request.fields['ownerId'] = post.ownerId!.toString();
      request.fields['categoryId'] = post.categoryId!.toString();
      request.fields['date'] = post.postingDate!;

      var response = await request.send();

      if (response.statusCode != postSuccessCode) return false;
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updatePost(SalePostEntity post, String token) async {
    final requestUrl = "$baseUrl/sale-object/update";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(requestUrl));

      request.headers.addAll({
        "authorization": "Bearear $token",
        "Content-type": "multipart/form-data"
      });

      for (int i = 0; i < post.images.length; i++) {
        final file = http.MultipartFile.fromBytes('images', post.images[i],
            filename: 'images$i.jpg', contentType: MediaType('image', 'jpeg'));
        request.files.add(file);
      }

      request.fields['id'] = post.postId.toString();
      request.fields['title'] = post.title;
      request.fields['description'] = post.description!;
      request.fields['price'] = post.price;
      request.fields['categoryId'] = post.categoryId!.toString();

      var response = await request.send();

      if (response.statusCode != postSuccessCode) return false;
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addToFavorites(
      {required String token, required int postId}) async {
    final requestUrl = "$baseUrl/sale-object/favorites/add";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'postId': postId}));

    return response.statusCode == postSuccessCode;
  }

  Future<bool> checkIfFavorite(
      {required String token, required int postId}) async {
    final requestUrl = "$baseUrl/sale-object/favorites/check";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'postId': postId}));

    final bodyJson = json.decode(response.body) as Map<String, dynamic>;
    final result = bodyJson['result'] as bool;

    return result;
  }

  Future<bool> removeFromFavorites(
      {required String token, required int postId}) async {
    final requestUrl = "$baseUrl/sale-object/favorites/remove";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'postId': postId}));

    return response.statusCode == postSuccessCode;
  }

  Future<bool> createAddress(
      {required String token, required AddressEntity address}) async {
    final requestUrl = "$baseUrl/address/insert";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'name': address.name,
          'county': address.county,
          'city': address.city,
          'description': address.description
        }));

    return response.statusCode == postSuccessCode;
  }

  Future<List<AddressEntity>> readAddresses({required String token}) async {
    final requestUrl = "$baseUrl/address/read";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{}));

    final bodyJson =
        json.decode(response.body); // as List<Map<String, dynamic>>;

    List<AddressModel> addresses = [];

    for (var json in bodyJson) {
      addresses.add(AddressModel.fromJson(json));
    }

    return addresses;
  }

  Future<bool> updateAddress(
      {required String token, required AddressEntity address}) async {
    assert(address is AddressModel);
    final model = address as AddressModel;

    final requestUrl = "$baseUrl/address/update";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(model.toJson()));

    return response.statusCode == postSuccessCode;
  }

  Future<bool> deleteAddress(
      {required String token, required AddressEntity address}) async {
    final requestUrl = "$baseUrl/address/delete";
    final response = await http.post(Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'id': address.id}));

    return response.statusCode == postSuccessCode;
  }
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:student_marketplace_frontend/data/models/user/user_model.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
      lastName: 'lastNameTest',
      secondaryLastName: "secondaryLastNameTest",
      facultyName: "facultyNameTest",
      emailAddress: "emailAddressTest",
      firstName: "firstNameTest");

  final tPartialUserModel = UserModel(
      lastName: 'lastNameTest',
      secondaryLastName: null,
      facultyName: "facultyNameTest",
      emailAddress: "emailAddressTest",
      firstName: "firstNameTest");

  test('should be a subtype of User entity', () async {
    // arange

    // act

    // assert
    expect(tUserModel, isA<UserModel>());
  });

  group('fromJson', () {
    test(
        'should return a valid User model when passing a valid auth json containing secondaryLastName key',
        () async {
      // arange
      final Map<String, dynamic> jsonMap =
          json.decode(readFixture('valid_user.json'));
      // act
      final result = UserModel.fromJson(jsonMap);

      // assert
      expect(result, tUserModel);
    });

    test(
        'should return a valid User model when passing a valid auth json not containing secondaryLastName key',
        () async {
      // arange
      final Map<String, dynamic> jsonMap =
          json.decode(readFixture('valid_partial_user.json'));
      // act
      final result = UserModel.fromJson(jsonMap);

      // assert
      expect(result, tPartialUserModel);
      expect(result?.secondaryLastName, null);
    });
    test('should return a null User model when passing an  invalid auth json',
        () async {
      // arange
      final Map<String, dynamic> jsonMap =
          json.decode(readFixture('invalid_user.json'));
      // act
      final result = UserModel.fromJson(jsonMap);

      // assert
      expect(result, null);
    });
  });

  group('toJson', () {
    test('should a return a json map containing the proper data', () async {
      // arange

      // act

      final result = tUserModel.toJson();

      // assert
      final jsonMap = {
        "firstName": "firstNameTest",
        "lastName": "lastNameTest",
        "secondaryLastName": "secondaryLastNameTest",
        "facultyName": "facultyNameTest",
        "emailAddress": "emailAddressTest"
      };

      expect(result, jsonMap);
    });
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:student_marketplace_frontend/data/models/user/authentication_credentials_model.dart';
import 'package:student_marketplace_frontend/domain/entities/user/authentication_credentials.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tAuthenticationCredentialsModel =
      AuthenticationCredentialsModel(email: 'test@gmail.com', password: 'pass');
  test('should be a subtype of AuthenticationCredentials entity', () async {
    // arange

    // act

    // assert
    expect(tAuthenticationCredentialsModel, isA<AuthenticationCredentials>());
  });

  final tAuthCredentialsModel = AuthenticationCredentialsModel(
      email: 'test@gmail.com', password: 'password');

  group('fromJson', () {
    test('should return a valid model when passing a valid auth json',
        () async {
      // arange
      final Map<String, dynamic> jsonMap =
          json.decode(readFixture('valid_auth_credentials.json'));
      // act
      final result = AuthenticationCredentialsModel.fromJson(jsonMap);

      // assert
      expect(result, tAuthCredentialsModel);
    });

    test('should return a null model when passing an  invalid auth json',
        () async {
      // arange
      final Map<String, dynamic> jsonMap =
          json.decode(readFixture('invalid_auth_credentials.json'));
      // act
      final result = AuthenticationCredentialsModel.fromJson(jsonMap);

      // assert
      expect(result, null);
    });
  });

  group('toJson', () {
    test('should a return a json map containing the proper data', () async {
      // arange

      // act

      final result = tAuthenticationCredentialsModel.toJson();

      // assert
      final jsonMap = {'email': 'test@gmail.com', 'password': 'pass'};
      expect(result, jsonMap);
    });
  });
}

import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_marketplace_frontend/domain/entities/user/authentication_credentials.dart';
import 'package:student_marketplace_frontend/domain/usecases/authentication_credentials/sign_in_user.dart';

import 'authentication_credentials_repository_mocks.dart';

void main() {
  late MockAuthenticationCredentialsRepository
      mockAuthenticationCredentialsRepository;

  late SignInUser usecase;

  setUp(() {
    mockAuthenticationCredentialsRepository =
        MockAuthenticationCredentialsRepository();
    usecase = SignInUser(repository: mockAuthenticationCredentialsRepository);
  });

  test('should log in user', () async {
    // arange
    when(mockAuthenticationCredentialsRepository.signInUser())
        .thenAnswer((_) async => const Right('token'));
    // act
    final result = await usecase();

    // assert
    expect(result, const Right('token'));
    verify(mockAuthenticationCredentialsRepository.signInUser());
  });
}

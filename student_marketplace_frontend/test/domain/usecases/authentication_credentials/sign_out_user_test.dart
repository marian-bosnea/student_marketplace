import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_marketplace_frontend/domain/usecases/authentication_credentials/sign_out_user.dart';
import 'authentication_credentials_repository_mocks.dart';

void main() {
  late MockAuthenticationCredentialsRepository
      mockAuthenticationCredentialsRepository;

  late SignOutUser usecase;

  setUp(() {
    mockAuthenticationCredentialsRepository =
        MockAuthenticationCredentialsRepository();
    usecase = SignOutUser(repository: mockAuthenticationCredentialsRepository);
  });

  final token = 'token';

  test('should sign out user', () async {
    // arange
    when(mockAuthenticationCredentialsRepository.signOutUser(token))
        .thenAnswer((_) async => Right(true));
    // act
    final result = await usecase(token: token);

    // assert
    expect(result, const Right(true));
    verify(mockAuthenticationCredentialsRepository.signOutUser('token'));
  });
}

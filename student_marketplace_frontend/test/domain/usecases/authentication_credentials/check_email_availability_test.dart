import 'package:dartz/dartz.dart';
import 'package:student_marketplace_frontend/domain/entities/user/authentication_credentials.dart';
import 'package:student_marketplace_frontend/domain/repositories/authentication_credentials_repository.dart';
import 'package:student_marketplace_frontend/domain/usecases/authentication_credentials/check_email_availability.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'check_email_availability_test.mocks.dart';

@GenerateMocks([AuthenticationCredentialsRepository])
void main() {
  late CheckEmailAvailability usecase;
  late MockAuthenticationCredentialsRepository
      mockAuthenticationCredentialsRepository;

  setUp(() {
    mockAuthenticationCredentialsRepository =
        MockAuthenticationCredentialsRepository();
    usecase = CheckEmailAvailability(
        repository: mockAuthenticationCredentialsRepository);
  });

  const email = 'test@gmail.com';
  const AuthenticationCredentials authenticationCredentials =
      AuthenticationCredentials(email: 'test@gmail.com', password: 'test');

  test('should check if email is already used', () async {
    // arange
    when(mockAuthenticationCredentialsRepository.checkEmailAvailability(email))
        .thenAnswer((_) async => const Right(true));

    // act
    final result = await usecase(email: email);

    // assert
    expect(result, const Right(true));
    verify(
        mockAuthenticationCredentialsRepository.checkEmailAvailability(email));
    //    verifyNoMoreInteractions(
    //      mockAuthenticationCredentialsRepository.checkEmailAvailability(email));
  });
}

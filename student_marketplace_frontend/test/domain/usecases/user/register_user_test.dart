import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/domain/repositories/user/user_repostory.dart';
import 'package:student_marketplace_frontend/domain/usecases/user/register_user.dart';

import 'user_repository_mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockUserRepository;
  late RegisterUser usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = RegisterUser(repository: mockUserRepository);
  });

  test('should register the user', () async {
    // arange
    when(mockUserRepository.registerUser())
        .thenAnswer((_) async => const Right(true));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(true));
    verify(mockUserRepository.registerUser());
  });
}

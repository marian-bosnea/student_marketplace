import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:student_marketplace_frontend/domain/usecases/user/update_user.dart';

import 'user_repository_mocks.dart';

void main() {
  late MockUserRepository mockUserRepository;
  late UpdateUser usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UpdateUser(repository: mockUserRepository);
  });

  test('should update the user information', () async {
    // arange
    when(mockUserRepository.updateUser())
        .thenAnswer((_) async => const Right(true));
    // act

    final result = await usecase();

    // assert
    expect(result, const Right(true));
    verify(mockUserRepository.updateUser());
  });
}

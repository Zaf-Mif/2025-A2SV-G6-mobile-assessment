// test/features/auth/domain/usecases/logout_test.dart

import 'package:chat_app/features/authentication/core/usecases/usecases.dart';
import 'package:chat_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:chat_app/features/authentication/domain/usecases/logout.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Logout usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Logout(mockAuthRepository);
  });

  test('should call logout on the repository and return Right', () async {
    // arrange
    when(() => mockAuthRepository.logout())
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, equals(const Right(null)));
    verify(() => mockAuthRepository.logout()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}

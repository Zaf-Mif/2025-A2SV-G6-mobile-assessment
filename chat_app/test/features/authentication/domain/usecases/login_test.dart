import 'package:chat_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:chat_app/features/authentication/domain/usecases/login.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Login usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Login(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tToken = 'test_token';

  test('should return token string when login is successful', () async {
    // arrange
    when(() => mockAuthRepository.login(tEmail, tPassword))
        .thenAnswer((_) async => const Right(tToken));

    // act
    final result = await usecase(const LoginParams(email: tEmail, password: tPassword));

    // assert
    expect(result, equals(const Right(tToken)));
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
